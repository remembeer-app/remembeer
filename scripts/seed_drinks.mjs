#!/usr/bin/env node

/**
 * Seeds the global drinks from assets/seed_data/drinks.json.
 *
 * Global drinks carry userId "global", which firestore.rules forbids every
 * client from writing (a client may only write documents whose userId equals its
 * own uid). Seeding therefore has to go through the Admin SDK, which bypasses
 * rules.
 *
 * Usage:
 *   GOOGLE_APPLICATION_CREDENTIALS=/path/to/service-account.json npm run seed
 *
 * Against the emulator (no credentials needed):
 *   firebase emulators:start --only firestore
 *   FIRESTORE_EMULATOR_HOST=localhost:8080 npm run seed
 *
 * Pass --dry-run to print the planned changes without writing anything.
 */

import { readFile } from 'node:fs/promises';
import { fileURLToPath } from 'node:url';
import { dirname, resolve } from 'node:path';

import { cert, initializeApp } from 'firebase-admin/app';
import { FieldValue, getFirestore } from 'firebase-admin/firestore';

const PROJECT_ID = 'remembeer-pivo';
const COLLECTION = 'drinks';
const GLOBAL_USER_ID = 'global';
// Firestore caps a batch at 500 operations.
const BATCH_LIMIT = 500;

const repoRoot = resolve(dirname(fileURLToPath(import.meta.url)), '..');
const seedFile = resolve(repoRoot, 'assets/seed_data/drinks.json');

const dryRun = process.argv.includes('--dry-run');

async function initialize() {
  const emulator = process.env.FIRESTORE_EMULATOR_HOST;
  const credentialsPath = process.env.GOOGLE_APPLICATION_CREDENTIALS;

  if (emulator) {
    console.log(`Using the Firestore emulator at ${emulator}.`);
    initializeApp({ projectId: PROJECT_ID });
    return;
  }

  if (!credentialsPath) {
    throw new Error(
      'Set GOOGLE_APPLICATION_CREDENTIALS to a service account JSON key, or ' +
        'set FIRESTORE_EMULATOR_HOST to seed the emulator instead.',
    );
  }

  const serviceAccount = JSON.parse(await readFile(credentialsPath, 'utf8'));
  if (serviceAccount.project_id !== PROJECT_ID) {
    throw new Error(
      `The service account belongs to project "${serviceAccount.project_id}", ` +
        `expected "${PROJECT_ID}".`,
    );
  }

  console.log(`Using service account ${serviceAccount.client_email}.`);
  initializeApp({ credential: cert(serviceAccount), projectId: PROJECT_ID });
}

async function readSeedFile() {
  const drinks = JSON.parse(await readFile(seedFile, 'utf8'));

  const ids = new Set();
  for (const drink of drinks) {
    if (drink.userId !== GLOBAL_USER_ID) {
      throw new Error(`${drink.id} is not a global drink.`);
    }
    if (ids.has(drink.id)) {
      throw new Error(`Duplicate id ${drink.id} in the seed file.`);
    }
    ids.add(drink.id);
  }

  return drinks;
}

/// Commits `operations` in chunks, since a single batch holds 500 writes.
async function commitInBatches(firestore, operations) {
  for (let index = 0; index < operations.length; index += BATCH_LIMIT) {
    const batch = firestore.batch();
    for (const apply of operations.slice(index, index + BATCH_LIMIT)) {
      apply(batch);
    }
    await batch.commit();
  }
}

async function main() {
  await initialize();

  const firestore = getFirestore();
  const collection = firestore.collection(COLLECTION);
  const drinks = await readSeedFile();
  const seededIds = new Set(drinks.map((drink) => drink.id));

  const existing = await collection
    .where('userId', '==', GLOBAL_USER_ID)
    .get();

  // Drinks dropped from the seed file are soft deleted so they stop
  // showing up in the picker. Logged drinks keep their own copy of the name,
  // category and alcohol percentage, so their history stays intact.
  const retired = existing.docs.filter(
    (doc) => !seededIds.has(doc.id) && doc.get('deletedAt') === null,
  );

  const existingById = new Map(existing.docs.map((doc) => [doc.id, doc]));
  const created = drinks.filter((drink) => !existingById.has(drink.id));

  console.log(
    `${drinks.length} drinks in the seed file: ` +
      `${created.length} new, ${drinks.length - created.length} updated, ` +
      `${retired.length} retired.`,
  );

  if (dryRun) {
    for (const drink of created) {
      console.log(`  + ${drink.id}`);
    }
    for (const doc of retired) {
      console.log(`  - ${doc.id}`);
    }
    console.log('Dry run, nothing written.');
    return;
  }

  const operations = [
    ...drinks.map((drink) => (batch) => {
      // Reseeding must not restamp createdAt on drinks that already exist.
      const createdAt =
        existingById.get(drink.id)?.get('createdAt') ??
        FieldValue.serverTimestamp();

      batch.set(collection.doc(drink.id), {
        ...drink,
        createdAt,
        updatedAt: FieldValue.serverTimestamp(),
        deletedAt: null,
      });
    }),
    ...retired.map((doc) => (batch) => {
      batch.update(doc.ref, {
        updatedAt: FieldValue.serverTimestamp(),
        deletedAt: FieldValue.serverTimestamp(),
      });
    }),
  ];

  await commitInBatches(firestore, operations);
  console.log('Done.');
}

main().catch((error) => {
  console.error(error.message);
  process.exitCode = 1;
});

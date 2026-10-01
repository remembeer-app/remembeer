const { readFileSync } = require('node:fs');
const { after, before, beforeEach, describe, test } = require('node:test');
const assert = require('node:assert/strict');
const {
  assertFails,
  assertSucceeds,
  initializeTestEnvironment,
} = require('@firebase/rules-unit-testing');
const firebase = require('firebase/compat/app');
require('firebase/compat/firestore');
const { arrayRemove } = firebase.firestore.FieldValue;

const projectId = 'remembeer-rules-test';
const partyId = 'party-active';
const archivedPartyId = 'party-archived';
const indexConfig = JSON.parse(readFileSync('firestore.indexes.json', 'utf8'));
let testEnv;

const session = (overrides = {}) => ({
  userId: 'owner',
  memberIds: ['owner', 'admin', 'member'],
  adminIds: ['owner', 'admin'],
  bannedMemberIds: [],
  name: 'Friday',
  description: '',
  startedAt: '2026-09-04T18:00:00.000Z',
  endedAt: null,
  drinks: [],
  isSoloSession: false,
  isParty: true,
  deletedAt: null,
  updatedAt: 'before',
  pictureUrls: [],
  ...overrides,
});

const user = (overrides = {}) => ({
  email: 'member@example.com',
  username: 'Member',
  searchableUsername: 'member',
  accentColorKey: 'amber',
  friends: [],
  monthlyStats: {},
  unlockedBadges: {},
  endOfDayBoundary: { hour: 6, minute: 0 },
  ...overrides,
});

async function seed() {
  await testEnv.withSecurityRulesDisabled(async (context) => {
    const db = context.firestore();
    await db.doc(`sessions/${partyId}`).set(session());
    await db.doc(`sessions/${archivedPartyId}`).set(
      session({ endedAt: '2026-09-05T02:00:00.000Z' }),
    );
    await db.doc(`parties/${partyId}`).set({
      sessionId: partyId,
      status: 'active',
      moduleSettings: { socialQuestsEnabled: true },
    });
    await db.doc(`parties/${archivedPartyId}`).set({
      sessionId: archivedPartyId,
      status: 'archived',
    });

    const nestedDocuments = [
      'members/member',
      'events/event-1',
      'commands/command-1',
      'aggregates/totals',
      'questTemplates/template-1',
      'quests/quest-1',
      'quests/quest-1/selections/member',
      'challenges/challenge-1',
      'tournaments/tournament-1',
      'tournaments/tournament-1/teams/team-1',
      'tournaments/tournament-1/matches/match-1',
    ];
    for (const path of nestedDocuments) {
      await db.doc(`parties/${partyId}/${path}`).set({ value: 'protected' });
      await db.doc(`parties/${archivedPartyId}/${path}`).set({
        value: 'archived',
      });
    }
    await db.doc('users/member').set(user());
    await db.doc('users/other').set(user({
      email: 'other@example.com',
      username: 'Other',
      searchableUsername: 'other',
    }));
  });
}

before(async () => {
  testEnv = await initializeTestEnvironment({
    projectId,
    firestore: {
      rules: readFileSync('firestore.rules', 'utf8'),
    },
  });
});

beforeEach(async () => {
  await testEnv.clearFirestore();
  await seed();
});

after(async () => {
  await testEnv.cleanup();
});

describe('Session-backed Party reads', () => {
  const paths = [
    '',
    '/members/member',
    '/events/event-1',
    '/commands/command-1',
    '/aggregates/totals',
    '/questTemplates/template-1',
    '/quests/quest-1',
    '/quests/quest-1/selections/member',
    '/challenges/challenge-1',
    '/tournaments/tournament-1',
    '/tournaments/tournament-1/teams/team-1',
    '/tournaments/tournament-1/matches/match-1',
  ];

  test('members and admins can read active and archived Party paths', async () => {
    for (const actor of ['member', 'admin']) {
      const db = testEnv.authenticatedContext(actor).firestore();
      for (const id of [partyId, archivedPartyId]) {
        for (const path of paths) {
          await assertSucceeds(db.doc(`parties/${id}${path}`).get());
        }
      }
    }
  });

  test('signed-in non-members can read active and archived Party paths except command receipts', async () => {
    const db = testEnv.authenticatedContext('outsider').firestore();
    for (const id of [partyId, archivedPartyId]) {
      for (const path of paths) {
        const read = db.doc(`parties/${id}${path}`).get();
        if (path.startsWith('/commands/')) {
          await assertFails(read);
        } else {
          await assertSucceeds(read);
        }
      }
    }
    await assertFails(db.collection(`parties/${partyId}/commands`).get());
  });

  test('unauthenticated users cannot read any Party path', async () => {
    const db = testEnv.unauthenticatedContext().firestore();
    for (const id of [partyId, archivedPartyId]) {
      for (const path of paths) {
        await assertFails(db.doc(`parties/${id}${path}`).get());
      }
    }
  });

  test('non-members cannot write any Party path', async () => {
    const db = testEnv.authenticatedContext('outsider').firestore();
    for (const path of paths) {
      await assertFails(db.doc(`parties/${partyId}${path}`).set({ forged: true }));
    }
    await assertFails(db.doc(`parties/${partyId}/events/new-event`).set({ forged: true }));
  });

  test('actual Party collection queries authorize signed-in users', async () => {
    const memberDb = testEnv.authenticatedContext('member').firestore();
    const outsiderDb = testEnv.authenticatedContext('outsider').firestore();
    const unauthenticatedDb = testEnv.unauthenticatedContext().firestore();
    const queriesFor = (db) => {
      const party = db.doc(`parties/${partyId}`);
      return [
        party.collection('members').orderBy('scoreUnits', 'desc').orderBy('userId'),
        party.collection('events').orderBy('occurredAt', 'desc'),
        party.collection('events').where('kind', '==', 'drink').orderBy('occurredAt', 'desc'),
        party.collection('events').where('participantIds', 'array-contains', 'member').orderBy('occurredAt', 'desc'),
        party.collection('events').where('participantIds', 'array-contains-any', ['member']).where('kind', 'in', ['drink']).orderBy('occurredAt', 'desc'),
        party.collection('events').where('sourceCollection', '==', 'challenges').where('sourceId', '==', 'challenge-1'),
        party.collection('questTemplates').orderBy('title'),
        party.collection('quests').orderBy('createdAt', 'desc'),
        party.collection('challenges').orderBy('createdAt', 'desc'),
        party.collection('tournaments').orderBy('createdAt', 'desc'),
        party.collection('tournaments/tournament-1/teams').orderBy('seed'),
        party.collection('tournaments/tournament-1/matches').orderBy('round').orderBy('position'),
      ];
    };
    for (const db of [memberDb, outsiderDb]) {
      for (const query of queriesFor(db)) {
        await assertSucceeds(query.get());
      }
    }
    await assertFails(
      unauthenticatedDb
        .collection(`parties/${partyId}/events`)
        .orderBy('occurredAt', 'desc')
        .get(),
    );
  });
});

describe('Party indexes', () => {
  const signature = (index) => [
    index.collectionGroup,
    index.queryScope,
    ...index.fields
      .filter((field) => field.fieldPath !== '__name__')
      .map((field) => `${field.fieldPath}:${field.order || field.arrayConfig}`),
  ].join('|');
  const signatures = new Set(indexConfig.indexes.map(signature));

  test('contains every composite required by client and scheduler queries', () => {
    const expected = [
      'parties|COLLECTION|status:ASCENDING|moduleSettings.socialQuestsEnabled:ASCENDING|questSchedule.nextQuestAt:ASCENDING',
      'members|COLLECTION|scoreUnits:DESCENDING|userId:ASCENDING',
      'events|COLLECTION|kind:ASCENDING|occurredAt:DESCENDING',
      'events|COLLECTION|participantIds:CONTAINS|occurredAt:DESCENDING',
      'events|COLLECTION|participantIds:CONTAINS|kind:ASCENDING|occurredAt:DESCENDING',
      'events|COLLECTION|sourceCollection:ASCENDING|sourceId:ASCENDING',
      'quests|COLLECTION_GROUP|status:ASCENDING|endsAt:ASCENDING',
      'challenges|COLLECTION_GROUP|status:ASCENDING|endsAt:ASCENDING',
      'matches|COLLECTION|round:ASCENDING|position:ASCENDING',
    ];
    for (const expectedSignature of expected) {
      assert(signatures.has(expectedSignature), `Missing ${expectedSignature}`);
    }
  });

  test('disables only identified unqueried large fields', () => {
    assert.deepEqual(
      indexConfig.fieldOverrides.map(
        (override) => `${override.collectionGroup}.${override.fieldPath}`,
      ),
      [
        'commands.result',
        'events.payload',
        'questTemplates.instructions',
        'quests.instructionsSnapshot',
        'challenges.instructions',
      ],
    );
    assert(indexConfig.fieldOverrides.every((override) => override.indexes.length === 0));
  });
});

describe('callable-only Party state', () => {
  const protectedPaths = [
    '',
    '/members/member',
    '/events/event-1',
    '/commands/command-1',
    '/aggregates/totals',
    '/questTemplates/template-1',
    '/quests/quest-1',
    '/quests/quest-1/selections/member',
    '/challenges/challenge-1',
    '/tournaments/tournament-1',
    '/tournaments/tournament-1/teams/team-1',
    '/tournaments/tournament-1/matches/match-1',
  ];

  test('members, admins, and owners cannot create, update, or delete protected state', async () => {
    for (const actor of ['member', 'admin', 'owner']) {
      const db = testEnv.authenticatedContext(actor).firestore();
      for (const path of protectedPaths) {
        const ref = db.doc(`parties/${partyId}${path}`);
        await assertFails(ref.set({ forged: true }, { merge: true }));
        await assertFails(ref.delete());
      }
      await assertFails(
        db.doc(`parties/${partyId}/events/new-event`).set({ forged: true }),
      );
      await assertFails(
        db.doc(`parties/${partyId}/quests/quest-1/selections/new`).set({
          forged: true,
        }),
      );
    }
  });

  test('archived Party documents remain readable but reject every direct mutation', async () => {
    const db = testEnv.authenticatedContext('owner').firestore();
    for (const path of protectedPaths) {
      const ref = db.doc(`parties/${archivedPartyId}${path}`);
      await assertSucceeds(ref.get());
      await assertFails(ref.set({ forged: true }, { merge: true }));
      await assertFails(ref.delete());
    }
  });
});

describe('Party Session protection', () => {
  test('direct activation is denied', async () => {
    const db = testEnv.authenticatedContext('owner').firestore();
    await testEnv.withSecurityRulesDisabled((context) =>
      context.firestore().doc('sessions/ordinary').set(
        session({ isParty: false, memberIds: ['owner'], adminIds: ['owner'] }),
      ),
    );
    await assertFails(db.doc('sessions/ordinary').update({ isParty: true }));
    await assertFails(
      db.doc('parties/ordinary').set({
        sessionId: 'ordinary',
        status: 'active',
      }),
    );
  });

  test('Party lifecycle, membership, and embedded drinks are callable-only', async () => {
    const protectedUpdates = [
      { drinks: [{ id: 'forged' }] },
      { startedAt: '2026-09-04T19:00:00.000Z' },
      { endedAt: '2026-09-05T01:00:00.000Z' },
      { memberIds: ['owner', 'admin', 'member', 'outsider'] },
      { deletedAt: '2026-09-05T01:00:00.000Z' },
      { isParty: false },
    ];
    for (const actor of ['member', 'admin', 'owner']) {
      const ref = testEnv
        .authenticatedContext(actor)
        .firestore()
        .doc(`sessions/${partyId}`);
      for (const update of protectedUpdates) {
        await assertFails(ref.update(update));
      }
    }
  });

  test('archived Party Sessions reject presentation and role updates', async () => {
    const ref = testEnv
      .authenticatedContext('owner')
      .firestore()
      .doc(`sessions/${archivedPartyId}`);
    await assertFails(ref.update({ name: 'Changed after archive' }));
    await assertFails(ref.update({ adminIds: ['owner'] }));
    await assertFails(ref.update({ pictureUrls: ['forged'] }));
  });

  test('non-Party owner, admin, and member flows remain available', async () => {
    await testEnv.withSecurityRulesDisabled(async (context) => {
      await context.firestore().doc('sessions/ordinary').set(
        session({ isParty: false }),
      );
    });
    const ownerRef = testEnv
      .authenticatedContext('owner')
      .firestore()
      .doc('sessions/ordinary');
    const adminRef = testEnv
      .authenticatedContext('admin')
      .firestore()
      .doc('sessions/ordinary');
    const memberRef = testEnv
      .authenticatedContext('member')
      .firestore()
      .doc('sessions/ordinary');

    await assertSucceeds(ownerRef.update({ endedAt: '2026-09-05T01:00:00Z' }));
    await assertSucceeds(adminRef.update({ drinks: [], updatedAt: 'admin' }));
    await assertSucceeds(memberRef.update({ drinks: [], updatedAt: 'member' }));
    await assertSucceeds(
      testEnv.authenticatedContext('owner').firestore().collection('sessions').add(
        session({ isParty: false, memberIds: ['owner'], adminIds: ['owner'] }),
      ),
    );
  });

  test('non-protected Party Session presentation and admin-role updates remain valid', async () => {
    const ownerRef = testEnv
      .authenticatedContext('owner')
      .firestore()
      .doc(`sessions/${partyId}`);
    await assertSucceeds(ownerRef.update({ name: 'Renamed Party' }));
    await assertSucceeds(ownerRef.update({ adminIds: ['owner'] }));
  });
});

describe('user accent palette', () => {
  test('owner may update only accentColorKey to a palette-v1 value', async () => {
    const ref = testEnv
      .authenticatedContext('member')
      .firestore()
      .doc('users/member');
    const colors = [
      'amber',
      'rose',
      'violet',
      'sky',
      'emerald',
      'lime',
      'orange',
      'fuchsia',
    ];
    for (const accentColorKey of colors) {
      await assertSucceeds(ref.update({ accentColorKey }));
    }
    const snapshot = await assertSucceeds(ref.get());
    assert.equal(snapshot.data().username, 'Member');
    assert.equal(snapshot.data().accentColorKey, 'fuchsia');
  });

  test('invalid, removed, mixed-field, and non-owner accent updates are denied', async () => {
    const ownRef = testEnv
      .authenticatedContext('member')
      .firestore()
      .doc('users/member');
    await assertFails(ownRef.update({ accentColorKey: 'blue' }));
    await assertFails(ownRef.update({ accentColorKey: null }));
    await assertFails(
      ownRef.update({ accentColorKey: 'rose', username: 'Forged together' }),
    );
    await assertFails(
      testEnv
        .authenticatedContext('other')
        .firestore()
        .doc('users/member')
        .update({ accentColorKey: 'rose' }),
    );
  });

  test('owner profile updates and non-owner friend self-array changes still work', async () => {
    const ownRef = testEnv
      .authenticatedContext('member')
      .firestore()
      .doc('users/member');
    await assertSucceeds(ownRef.update({ username: 'Updated' }));

    const otherRef = testEnv
      .authenticatedContext('member')
      .firestore()
      .doc('users/other');
    await assertSucceeds(otherRef.update({ friends: ['member'] }));
    await assertSucceeds(otherRef.update({ friends: [] }));
    await assertFails(otherRef.update({ friends: ['someone-else'] }));
  });
});

describe('account deletion', () => {
  const memberDb = () => testEnv.authenticatedContext('member').firestore();
  const otherDb = () => testEnv.authenticatedContext('other').firestore();
  const thirdDb = () => testEnv.authenticatedContext('third').firestore();

  const drink = (id, consumedByUserId) => ({
    id,
    consumedByUserId,
    consumedAt: '2026-09-04T19:00:00.000Z',
    drinkType: { name: 'Beer', category: 'beer', alcoholPercentage: 4.5 },
    volumeInMilliliters: 500,
  });

  beforeEach(async () => {
    await testEnv.withSecurityRulesDisabled(async (context) => {
      const db = context.firestore();
      await db.doc('drink_types/own').set({
        userId: 'member',
        name: 'IPA',
        category: 'beer',
        alcoholPercentage: 6,
        deletedAt: null,
      });
      await db.doc('friend_requests/request').set({
        userId: 'member',
        toUserId: 'other',
        senderUsername: 'Member',
        deletedAt: null,
      });
      await db.doc('leaderboards/board').set({
        userId: 'member',
        memberIds: ['member', 'other'],
        bannedMemberIds: [],
        name: 'Board',
        iconName: 'beer',
        inviteCode: 'ABC123',
        deletedAt: null,
        updatedAt: 'before',
      });
      await db.doc('sessions/solo').set(
        session({
          userId: 'member',
          memberIds: ['member'],
          adminIds: ['member'],
          isSoloSession: true,
          isParty: false,
        }),
      );
      await db.doc('sessions/shared').set(
        session({
          userId: 'member',
          memberIds: ['member', 'other', 'third'],
          adminIds: ['member', 'other'],
          isParty: false,
          drinks: [drink('d1', 'member'), drink('d2', 'other')],
        }),
      );
      await db.doc('sessions/party-owned').set(
        session({
          userId: 'member',
          memberIds: ['member', 'other'],
          adminIds: ['member'],
          isParty: true,
        }),
      );
      await db.doc('user_settings/member').set({
        defaultDrinkSize: 500,
        notificationToken: 'token',
      });
    });
  });

  test('owner can hard-delete own drink type, leaderboard and non-party session', async () => {
    await assertSucceeds(memberDb().doc('drink_types/own').delete());
    await assertSucceeds(memberDb().doc('leaderboards/board').delete());
    await assertSucceeds(memberDb().doc('sessions/solo').delete());
    await assertSucceeds(memberDb().doc('sessions/shared').delete());
  });

  test('non-owner cannot hard-delete drink type, leaderboard or session', async () => {
    await assertFails(otherDb().doc('drink_types/own').delete());
    await assertFails(otherDb().doc('leaderboards/board').delete());
    await assertFails(otherDb().doc('sessions/shared').delete());
  });

  test('owner cannot hard-delete a Party session', async () => {
    await assertFails(memberDb().doc('sessions/party-owned').delete());
  });

  test('owner can hand a shared session over while leaving', async () => {
    await assertSucceeds(
      memberDb().doc('sessions/shared').update({
        userId: 'other',
        memberIds: ['other', 'third'],
        adminIds: ['other'],
        drinks: [drink('d2', 'other')],
        updatedAt: 'after',
      }),
    );
    const snapshot = await otherDb().doc('sessions/shared').get();
    assert.equal(snapshot.data().userId, 'other');
    assert.deepEqual(snapshot.data().memberIds, ['other', 'third']);
    assert.equal(snapshot.data().drinks.length, 1);
  });

  test('owner can hand a leaderboard over while leaving', async () => {
    await assertSucceeds(
      memberDb().doc('leaderboards/board').update({
        userId: 'other',
        memberIds: ['other'],
        updatedAt: 'after',
      }),
    );
    const snapshot = await otherDb().doc('leaderboards/board').get();
    assert.equal(snapshot.data().userId, 'other');
  });

  test('hand-over is denied for non-members, staying owners, extra fields, non-owners and Parties', async () => {
    await assertFails(
      memberDb().doc('leaderboards/board').update({
        userId: 'stranger',
        memberIds: ['other'],
        updatedAt: 'after',
      }),
    );
    await assertFails(
      memberDb().doc('leaderboards/board').update({
        userId: 'other',
        memberIds: ['member', 'other'],
        updatedAt: 'after',
      }),
    );
    await assertFails(
      memberDb().doc('leaderboards/board').update({
        userId: 'other',
        memberIds: ['other'],
        name: 'Renamed',
        updatedAt: 'after',
      }),
    );
    await assertFails(
      otherDb().doc('leaderboards/board').update({
        userId: 'other',
        memberIds: ['other'],
        updatedAt: 'after',
      }),
    );
    await assertFails(
      memberDb().doc('sessions/party-owned').update({
        userId: 'other',
        memberIds: ['other'],
        adminIds: [],
        drinks: [],
        updatedAt: 'after',
      }),
    );
  });

  test('an admin member can strip own drinks and leave, removing self from admins', async () => {
    await assertSucceeds(
      otherDb().doc('sessions/shared').update({
        drinks: [drink('d1', 'member')],
        memberIds: arrayRemove('other'),
        adminIds: arrayRemove('other'),
        updatedAt: 'after',
      }),
    );
    const snapshot = await memberDb().doc('sessions/shared').get();
    assert.deepEqual(snapshot.data().memberIds, ['member', 'third']);
    assert.deepEqual(snapshot.data().adminIds, ['member']);
    assert.equal(snapshot.data().drinks.length, 1);
  });

  test('a plain member can strip own drinks and leave although not an admin', async () => {
    await assertSucceeds(
      thirdDb().doc('sessions/shared').update({
        drinks: [drink('d1', 'member'), drink('d2', 'other')],
        memberIds: arrayRemove('third'),
        adminIds: arrayRemove('third'),
        updatedAt: 'after',
      }),
    );
    const snapshot = await memberDb().doc('sessions/shared').get();
    assert.deepEqual(snapshot.data().memberIds, ['member', 'other']);
    assert.deepEqual(snapshot.data().adminIds, ['member', 'other']);
  });

  test('sender and recipient can delete a friend request, a third user cannot', async () => {
    await assertFails(thirdDb().doc('friend_requests/request').delete());
    await assertSucceeds(otherDb().doc('friend_requests/request').delete());
    await testEnv.withSecurityRulesDisabled(async (context) => {
      await context.firestore().doc('friend_requests/request').set({
        userId: 'member',
        toUserId: 'other',
        senderUsername: 'Member',
        deletedAt: null,
      });
    });
    await assertSucceeds(memberDb().doc('friend_requests/request').delete());
  });

  test('owner can write the anonymized profile, another user cannot', async () => {
    const anonymized = {
      email: '',
      username: 'Deleted user',
      searchableUsername: '',
      accentColorKey: 'amber',
      avatarUrl: null,
      friends: [],
      monthlyStats: {},
      unlockedBadges: {},
      endOfDayBoundary: { hour: 6, minute: 0 },
      deletedAt: 'now',
      updatedAt: 'now',
    };
    await assertFails(otherDb().doc('users/member').set(anonymized));
    await assertSucceeds(memberDb().doc('users/member').set(anonymized));
    const snapshot = await otherDb().doc('users/member').get();
    assert.equal(snapshot.data().username, 'Deleted user');
    assert.equal(snapshot.data().email, '');
  });

  test('owner can delete own user settings, another user cannot', async () => {
    await assertFails(otherDb().doc('user_settings/member').delete());
    await assertSucceeds(memberDb().doc('user_settings/member').delete());
  });
});

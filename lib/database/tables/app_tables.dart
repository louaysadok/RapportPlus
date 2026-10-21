import 'package:drift/drift.dart';

// ── User Profile (single row) ──
class UserProfiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get fullName => text().withLength(min: 0, max: 100).withDefault(const Constant(''))();
  TextColumn get institution => text().withDefault(const Constant(''))();
  TextColumn get specialization => text().withDefault(const Constant(''))();
  TextColumn get email => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get preferredLanguage => text().withDefault(const Constant('fr'))();
  BoolColumn get onboardingCompleted => boolean().withDefault(const Constant(false))();
  BoolColumn get googleDriveConnected => boolean().withDefault(const Constant(false))();
  TextColumn get googleDriveEmail => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

// ── Internships (multiple per user) ──
class Internships extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  TextColumn get companyName => text().withDefault(const Constant(''))();
  TextColumn get companyAddress => text().withDefault(const Constant(''))();
  TextColumn get supervisorName => text().nullable()();
  TextColumn get supervisorContact => text().nullable()();
  TextColumn get professionalField => text().withDefault(const Constant('Autre'))();
  TextColumn get internshipType => text().withDefault(const Constant('Stage PFE'))();
  DateTimeColumn get startDate => dateTime().nullable()();
  DateTimeColumn get endDate => dateTime().nullable()();
  TextColumn get objectives => text().withDefault(const Constant(''))();
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get status => text().withDefault(const Constant('active'))(); // active, completed, archived
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

// ── Daily Journal Entries ──
class JournalEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get internshipId => integer().customConstraint('REFERENCES internships(id) ON DELETE CASCADE')();
  DateTimeColumn get entryDate => dateTime()();
  TextColumn get rawContent => text().withDefault(const Constant(''))(); // original user notes
  TextColumn get correctedContent => text().nullable()(); // AI-corrected French
  TextColumn get activityType => text().withDefault(const Constant('unknown'))(); // performed, observed, etc.
  TextColumn get mood => text().nullable()();
  TextColumn get tags => text().withDefault(const Constant(''))(); // comma-separated
  TextColumn get questionnaireAnswers => text().withDefault(const Constant('{}'))(); // JSON
  TextColumn get skills => text().withDefault(const Constant(''))();
  TextColumn get toolsUsed => text().withDefault(const Constant(''))();
  BoolColumn get isDraft => boolean().withDefault(const Constant(false))();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  IntColumn get wordCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

// ── Media Attachments ──
class MediaAttachments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get entryId => integer().nullable().customConstraint('REFERENCES journal_entries(id) ON DELETE CASCADE')();
  IntColumn get internshipId => integer().customConstraint('REFERENCES internships(id) ON DELETE CASCADE')();
  TextColumn get fileName => text()();
  TextColumn get filePath => text()(); // local path
  TextColumn get mimeType => text()();
  IntColumn get fileSize => integer().withDefault(const Constant(0))();
  TextColumn get caption => text().nullable()();
  BoolColumn get includeInReport => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// ── Report Chapters ──
class ReportChapters extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get internshipId => integer().customConstraint('REFERENCES internships(id) ON DELETE CASCADE')();
  IntColumn get orderIndex => integer()();
  TextColumn get title => text()(); // e.g., "Présentation de l'entreprise"
  TextColumn get titleKey => text()(); // slug for templates
  TextColumn get content => text().withDefault(const Constant(''))(); // AI + user edited
  TextColumn get originalAiContent => text().nullable()();
  TextColumn get userNotes => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('draft'))(); // draft, ai_generated, approved, hidden
  IntColumn get completeness => integer().withDefault(const Constant(0))(); // 0-100
  BoolColumn get isVisible => boolean().withDefault(const Constant(true))();
  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

// ── Jury Questions ──
class JuryQuestions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get internshipId => integer().customConstraint('REFERENCES internships(id) ON DELETE CASCADE')();
  TextColumn get question => text()();
  TextColumn get suggestedAnswer => text().nullable()();
  TextColumn get userAnswer => text().nullable()();
  TextColumn get category => text().withDefault(const Constant('general'))();
  TextColumn get difficulty => text().withDefault(const Constant('medium'))();
  IntColumn get timesPracticed => integer().withDefault(const Constant(0))();
  IntColumn get lastScore => integer().nullable()(); // 0-10
  TextColumn get status => text().withDefault(const Constant('new'))(); // new, learning, mastered
  DateTimeColumn get lastPracticedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// ── Flashcards ──
class Flashcards extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get internshipId => integer().customConstraint('REFERENCES internships(id) ON DELETE CASCADE')();
  TextColumn get question => text()();
  TextColumn get shortAnswer => text()();
  TextColumn get detailedExplanation => text().nullable()();
  TextColumn get relatedChapter => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('new'))();
  DateTimeColumn get nextReviewAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// ── App Settings ──
class AppSettings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get key => text().unique()();
  TextColumn get value => text()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

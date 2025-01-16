// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

// Project imports:
import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_el.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_gl.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ka.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_uk.dart';
import 'app_localizations_zh.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localization/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('el'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('gl'),
    Locale('id'),
    Locale('it'),
    Locale('ja'),
    Locale('ka'),
    Locale('ko'),
    Locale('pl'),
    Locale('pt'),
    Locale('ru'),
    Locale('tr'),
    Locale('uk'),
    Locale('zh')
  ];

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @accentChangeMsg.
  ///
  /// In en, this message translates to:
  /// **'Accent color updated successfully'**
  String get accentChangeMsg;

  /// No description provided for @accentColor.
  ///
  /// In en, this message translates to:
  /// **'Accent color'**
  String get accentColor;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @addToLikedPlaylists.
  ///
  /// In en, this message translates to:
  /// **'Add to liked playlists'**
  String get addToLikedPlaylists;

  /// No description provided for @addToLikedSongs.
  ///
  /// In en, this message translates to:
  /// **'Add to liked songs'**
  String get addToLikedSongs;

  /// No description provided for @addToPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Add to playlist'**
  String get addToPlaylist;

  /// No description provided for @addedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Added successfully'**
  String get addedSuccess;

  /// No description provided for @album.
  ///
  /// In en, this message translates to:
  /// **'Album'**
  String get album;

  /// No description provided for @albums.
  ///
  /// In en, this message translates to:
  /// **'Albums'**
  String get albums;

  /// No description provided for @appUpdateIsAvailable.
  ///
  /// In en, this message translates to:
  /// **'An update is available'**
  String get appUpdateIsAvailable;

  /// No description provided for @artist.
  ///
  /// In en, this message translates to:
  /// **'Artist'**
  String get artist;

  /// No description provided for @audioQuality.
  ///
  /// In en, this message translates to:
  /// **'Audio quality'**
  String get audioQuality;

  /// No description provided for @audioQualityMsg.
  ///
  /// In en, this message translates to:
  /// **'Audio quality updated'**
  String get audioQualityMsg;

  /// No description provided for @automaticSongPicker.
  ///
  /// In en, this message translates to:
  /// **'Automatic song picker'**
  String get automaticSongPicker;

  /// No description provided for @backedupSuccess.
  ///
  /// In en, this message translates to:
  /// **'Data successfully backed up'**
  String get backedupSuccess;

  /// No description provided for @backupError.
  ///
  /// In en, this message translates to:
  /// **'Error occurred while backing up data'**
  String get backupError;

  /// No description provided for @backupUserData.
  ///
  /// In en, this message translates to:
  /// **'Backup user data'**
  String get backupUserData;

  /// No description provided for @becomeSponsor.
  ///
  /// In en, this message translates to:
  /// **'Become a sponsor'**
  String get becomeSponsor;

  /// No description provided for @cacheMsg.
  ///
  /// In en, this message translates to:
  /// **'Cache cleared'**
  String get cacheMsg;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @chooseBackupDir.
  ///
  /// In en, this message translates to:
  /// **'Choose backup folder'**
  String get chooseBackupDir;

  /// No description provided for @chooseBackupFiles.
  ///
  /// In en, this message translates to:
  /// **'Select files for backup'**
  String get chooseBackupFiles;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @clearCache.
  ///
  /// In en, this message translates to:
  /// **'Clear cache'**
  String get clearCache;

  /// No description provided for @clearRecentlyPlayed.
  ///
  /// In en, this message translates to:
  /// **'Clear recently played'**
  String get clearRecentlyPlayed;

  /// No description provided for @clearRecentlyPlayedQuestion.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear recently played history?'**
  String get clearRecentlyPlayedQuestion;

  /// No description provided for @clearSearchHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear search history'**
  String get clearSearchHistory;

  /// No description provided for @clearSearchHistoryQuestion.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear search history?'**
  String get clearSearchHistoryQuestion;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @confirmation.
  ///
  /// In en, this message translates to:
  /// **'Confirmation'**
  String get confirmation;

  /// No description provided for @copyLogs.
  ///
  /// In en, this message translates to:
  /// **'Copy logs'**
  String get copyLogs;

  /// No description provided for @copyLogsNoLogs.
  ///
  /// In en, this message translates to:
  /// **'No logs to copy'**
  String get copyLogsNoLogs;

  /// No description provided for @copyLogsSuccess.
  ///
  /// In en, this message translates to:
  /// **'Logs copied successfully'**
  String get copyLogsSuccess;

  /// No description provided for @customPlaylistImgUrl.
  ///
  /// In en, this message translates to:
  /// **'Custom playlist image URL'**
  String get customPlaylistImgUrl;

  /// No description provided for @customPlaylistName.
  ///
  /// In en, this message translates to:
  /// **'Custom playlist name'**
  String get customPlaylistName;

  /// No description provided for @deletePlaylist.
  ///
  /// In en, this message translates to:
  /// **'Delete playlist'**
  String get deletePlaylist;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @downloadAppUpdate.
  ///
  /// In en, this message translates to:
  /// **'Download app update'**
  String get downloadAppUpdate;

  /// No description provided for @dynamicColor.
  ///
  /// In en, this message translates to:
  /// **'Dynamic accent color (Android 12+)'**
  String get dynamicColor;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again.'**
  String get error;

  /// No description provided for @folderRestrictions.
  ///
  /// In en, this message translates to:
  /// **'Android restrictions require selecting specific folders (e.g., Documents or Downloads) for backup.'**
  String get folderRestrictions;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @invalidYouTubePlaylist.
  ///
  /// In en, this message translates to:
  /// **'Invalid YouTube playlist'**
  String get invalidYouTubePlaylist;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageMsg.
  ///
  /// In en, this message translates to:
  /// **'Language updated successfully'**
  String get languageMsg;

  /// No description provided for @library.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get library;

  /// No description provided for @licenses.
  ///
  /// In en, this message translates to:
  /// **'Licenses'**
  String get licenses;

  /// No description provided for @likedPlaylists.
  ///
  /// In en, this message translates to:
  /// **'Liked playlists'**
  String get likedPlaylists;

  /// No description provided for @likedSongs.
  ///
  /// In en, this message translates to:
  /// **'Liked songs'**
  String get likedSongs;

  /// No description provided for @lyrics.
  ///
  /// In en, this message translates to:
  /// **'Lyrics'**
  String get lyrics;

  /// No description provided for @lyricsNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Lyrics not available'**
  String get lyricsNotAvailable;

  /// No description provided for @makeOffline.
  ///
  /// In en, this message translates to:
  /// **'Make available offline'**
  String get makeOffline;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @newAnnouncement.
  ///
  /// In en, this message translates to:
  /// **'New announcement posted'**
  String get newAnnouncement;

  /// No description provided for @noCustomPlaylists.
  ///
  /// In en, this message translates to:
  /// **'No custom playlists created yet'**
  String get noCustomPlaylists;

  /// No description provided for @notYTlist.
  ///
  /// In en, this message translates to:
  /// **'Invalid YouTube playlist ID'**
  String get notYTlist;

  /// No description provided for @offlineMode.
  ///
  /// In en, this message translates to:
  /// **'Offline mode'**
  String get offlineMode;

  /// No description provided for @offlineSongs.
  ///
  /// In en, this message translates to:
  /// **'Offline songs'**
  String get offlineSongs;

  /// No description provided for @originalRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Original recommendation algorithm'**
  String get originalRecommendations;

  /// No description provided for @others.
  ///
  /// In en, this message translates to:
  /// **'Others'**
  String get others;

  /// No description provided for @playlist.
  ///
  /// In en, this message translates to:
  /// **'Playlist'**
  String get playlist;

  /// No description provided for @playlistAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'Playlist already exists'**
  String get playlistAlreadyExists;

  /// No description provided for @playlistUpdated.
  ///
  /// In en, this message translates to:
  /// **'Playlist updated successfully'**
  String get playlistUpdated;

  /// No description provided for @playlists.
  ///
  /// In en, this message translates to:
  /// **'Playlists'**
  String get playlists;

  /// No description provided for @predictiveBack.
  ///
  /// In en, this message translates to:
  /// **'Predictive back (Android 14+)'**
  String get predictiveBack;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @provideIdOrNameError.
  ///
  /// In en, this message translates to:
  /// **'Please provide a YouTube ID or custom playlist name'**
  String get provideIdOrNameError;

  /// No description provided for @pureBlackTheme.
  ///
  /// In en, this message translates to:
  /// **'Pure black theme'**
  String get pureBlackTheme;

  /// No description provided for @recentlyPlayed.
  ///
  /// In en, this message translates to:
  /// **'Recently played'**
  String get recentlyPlayed;

  /// No description provided for @recentlyPlayedMsg.
  ///
  /// In en, this message translates to:
  /// **'Recently played history cleared'**
  String get recentlyPlayedMsg;

  /// No description provided for @recommendedForYou.
  ///
  /// In en, this message translates to:
  /// **'Recommended for you'**
  String get recommendedForYou;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @removeFromLikedPlaylists.
  ///
  /// In en, this message translates to:
  /// **'Remove from liked playlists'**
  String get removeFromLikedPlaylists;

  /// No description provided for @removeFromLikedSongs.
  ///
  /// In en, this message translates to:
  /// **'Remove from liked songs'**
  String get removeFromLikedSongs;

  /// No description provided for @removeFromPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Remove from playlist'**
  String get removeFromPlaylist;

  /// No description provided for @removeOffline.
  ///
  /// In en, this message translates to:
  /// **'Remove from offline'**
  String get removeOffline;

  /// No description provided for @removePlaylistQuestion.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this playlist?'**
  String get removePlaylistQuestion;

  /// No description provided for @removeSearchQueryQuestion.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this search query?'**
  String get removeSearchQueryQuestion;

  /// No description provided for @restartAppMsg.
  ///
  /// In en, this message translates to:
  /// **'Restart the app to apply changes'**
  String get restartAppMsg;

  /// No description provided for @restoreError.
  ///
  /// In en, this message translates to:
  /// **'Error restoring data'**
  String get restoreError;

  /// No description provided for @restoreUserData.
  ///
  /// In en, this message translates to:
  /// **'Restore user data'**
  String get restoreUserData;

  /// No description provided for @restoredSuccess.
  ///
  /// In en, this message translates to:
  /// **'Data restored successfully'**
  String get restoredSuccess;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @searchHistoryMsg.
  ///
  /// In en, this message translates to:
  /// **'Search history cleared'**
  String get searchHistoryMsg;

  /// No description provided for @settingChangedMsg.
  ///
  /// In en, this message translates to:
  /// **'Settings updated successfully'**
  String get settingChangedMsg;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @songAdded.
  ///
  /// In en, this message translates to:
  /// **'Song added'**
  String get songAdded;

  /// No description provided for @songAlreadyInPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Song is already in the playlist'**
  String get songAlreadyInPlaylist;

  /// No description provided for @songRemoved.
  ///
  /// In en, this message translates to:
  /// **'Song removed'**
  String get songRemoved;

  /// No description provided for @songs.
  ///
  /// In en, this message translates to:
  /// **'Songs'**
  String get songs;

  /// No description provided for @sponsorProject.
  ///
  /// In en, this message translates to:
  /// **'Sponsor the project'**
  String get sponsorProject;

  /// No description provided for @suggestedArtists.
  ///
  /// In en, this message translates to:
  /// **'Suggested artists'**
  String get suggestedArtists;

  /// No description provided for @suggestedPlaylists.
  ///
  /// In en, this message translates to:
  /// **'Suggested playlists'**
  String get suggestedPlaylists;

  /// No description provided for @themeMode.
  ///
  /// In en, this message translates to:
  /// **'Theme mode'**
  String get themeMode;

  /// No description provided for @tools.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get tools;

  /// No description provided for @understand.
  ///
  /// In en, this message translates to:
  /// **'I understand'**
  String get understand;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @useSquigglySlider.
  ///
  /// In en, this message translates to:
  /// **'Squiggly slider'**
  String get useSquigglySlider;

  /// No description provided for @userPlaylists.
  ///
  /// In en, this message translates to:
  /// **'User playlists'**
  String get userPlaylists;

  /// No description provided for @youtubePlaylistLinkOrId.
  ///
  /// In en, this message translates to:
  /// **'YouTube playlist link or ID'**
  String get youtubePlaylistLinkOrId;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ar',
        'de',
        'el',
        'en',
        'es',
        'fr',
        'gl',
        'id',
        'it',
        'ja',
        'ka',
        'ko',
        'pl',
        'pt',
        'ru',
        'tr',
        'uk',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'el':
      return AppLocalizationsEl();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'gl':
      return AppLocalizationsGl();
    case 'id':
      return AppLocalizationsId();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ka':
      return AppLocalizationsKa();
    case 'ko':
      return AppLocalizationsKo();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'tr':
      return AppLocalizationsTr();
    case 'uk':
      return AppLocalizationsUk();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}

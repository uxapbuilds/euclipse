// ignore_for_file: constant_identifier_names
const myGitUrl = 'https://github.com/uxapbuilds';
const appVersion = '1.0.0';
List<Map<String, dynamic>> onboadingData = [
  {
    'title': 'Timetable',
    'desc':
        'Generate a time table of your class schedule to keep track of you every day hustle.',
    //'Generate time table of your college program to keep track of all the lectures.',
    'asset': ['assets/images/onb-timetable.png']
  },
  {
    'title': 'Summary',
    'desc':
        'Get a summary of all subjects.\nSave attended status & upload with relevant notes',
    //'Get a complete summary at the end of the day. Add Notes to lectures, update attended/unattended status & more.',
    'asset': ['assets/images/onb-summary.png']
  },
  {
    'title': 'Calendar',
    'desc':
        'Go back in past, see what subjects did you attend with notes sharing & management',
    //'You are not bound to just one day, go back in time and access previous details',
    'asset': ['assets/images/onb-calendar.png']
  },
  {
    'title': 'Todos, Assignments, Projects',
    'desc': 'Add & manage\nevery day side quests',
    //'You are not bound to just one day, go back in time and access previous details',
    'asset': [
      'assets/images/onb-subtask.jpg',
    ]
  },
];

const signupFields = ['First Name', 'Last Name', 'User Name', 'College/School'];
const timeTableDataFields = [
  'Subject Name',
  'Start Time',
  'End Time',
  'Lecturer Name',
  'Additional Details'
];

const oneCharaterDays = ['M', 'T', 'W', 'TH', 'F', 'S'];

const notificationIdDayMap = {
  'monday': 1,
  'tuesday': 2,
  'wednesday': 3,
  'thursday': 4,
  'friday': 5,
  'saturday': 6
};
const E_MINUTE_BEFORE_CODE = 53;
const E_MINUTE_END_CODE = 43;
//images
const NO_USER_IMAGE = 'assets/images/nouser.png';
const APP_ICO = 'assets/images/app_icon.png';
const BACKGROUND_A1 = 'assets/images/background_a1.svg';
const BACKGROUND_A2 = 'assets/images/background_a2.svg';
const BACKGROUND_A3 = 'assets/images/background_a3.svg';

//icons
const DAY_OFF = 'assets/images/sleep.png';

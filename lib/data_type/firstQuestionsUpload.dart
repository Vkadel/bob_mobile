import 'package:bob_mobile/data_type/book_question.dart';
import 'package:bob_mobile/modelData/provider.dart';
import 'package:flutter/cupertino.dart';

class BookQuestionUpload {
  BookQuestionUpload();

  void firstLargeUpload(BuildContext context) {
    BookQuestion question;
    question = new BookQuestion(
        'What was the name of the town where the hotel was?',
        'chesapeake',
        'Nags Head',
        'Peake Meadows',
        'Nagspeake',
        1,
        0,
        1);
    FireProvider.of(context).fireBase.uploadQuestion(question, 1);
    question = new BookQuestion(
        'In this book, the family owning the hotel was looking forward to a vacation for which holiday?',
        'Summer',
        'Spring Break',
        'Thanks Giving',
        'Christmas ',
        1,
        0,
        2);
    FireProvider.of(context).fireBase.uploadQuestion(question, 2);
    question = new BookQuestion(
        'What prompts Milo to start his adventure?',
        'An old crumbling letter',
        'The picture of a long lost treasure',
        'A history he heard from a stranger',
        'A strange blue stained map',
        1,
        0,
        3);
    FireProvider.of(context).fireBase.uploadQuestion(question, 3);
    question = new BookQuestion(
        'What is the name of the girl that susggest to Milo they should play the game called Odd Trails',
        'Madeline',
        'Mary',
        'Mila',
        'Meddy',
        1,
        0,
        4);
    FireProvider.of(context).fireBase.uploadQuestion(question, 4);
    question = new BookQuestion(
        'What did his playmate constantly nagged Milo about on during the game',
        'He was nagged for being too careful',
        'He was nagged for being too adventoruos',
        'He was nagged for not bringing proper equipment',
        'He was nagged to stay on character',
        1,
        0,
        5);
    FireProvider.of(context).fireBase.uploadQuestion(question, 5);
    question = new BookQuestion(
        'Milos last name is: ', 'Forest', 'Wood', 'Ash', 'Pines', 1, 0, 6);
    FireProvider.of(context).fireBase.uploadQuestion(question, 6);
    question = new BookQuestion('Milo favorite book genre is:', 'Adventures',
        'Novels', 'Thrillers', 'Mysteries', 1, 0, 7);
    FireProvider.of(context).fireBase.uploadQuestion(question, 7);
    question = new BookQuestion('The guests ocupation in this story was',
        'Treasure hunters', 'Detectives', 'Writers', 'Smugglers', 1, 0, 8);
    FireProvider.of(context).fireBase.uploadQuestion(question, 8);
    question = new BookQuestion('The main Characters, Milos, age is', '11',
        '10', 'The book does not say', '12', 1, 0, 9);
    FireProvider.of(context).fireBase.uploadQuestion(question, 9);
    question = new BookQuestion(
        'The cable car that allowed passage to the hotel in this story was named',
        'Whilforber Hill Climber',
        'Whilforber GorgeCruiser',
        'Whilforber Tornado',
        'Whilforber Whirlwind',
        1,
        0,
        10);
    FireProvider.of(context).fireBase.uploadQuestion(question, 10);
    question = new BookQuestion(
        'Part of the adventure required for Milo and his playmate to',
        'Get to interact with very few hotel guests',
        'Ignore everyone and focus on their own adventure',
        'Spy on all the guests ',
        'Get to know each of hotel guests',
        1,
        0,
        11);
    FireProvider.of(context).fireBase.uploadQuestion(question, 11);
    question = new BookQuestion('The author of this books is ', 'Ana Milford',
        'Kateryn Milford', 'Carolyn Milford', 'Kate Milford', 1, 0, 12);
    FireProvider.of(context).fireBase.uploadQuestion(question, 12);
    question = new BookQuestion('Milo playmate mom worked in the hotel doing:',
        'Serving Food', 'Guest check in', 'Cleaning', 'Cooking', 1, 0, 13);
    FireProvider.of(context).fireBase.uploadQuestion(question, 13);
    question = new BookQuestion('The author\'s name for this book',
        'Carolyn Van Draanen', '', '', 'Wendelin Van Draanen', 2, 0, 14);
    FireProvider.of(context).fireBase.uploadQuestion(question, 14);
    question = new BookQuestion(
        'What cause the main character to lose her leg?',
        'She got sick and they had to amputate',
        'She was in the war and walked over a mine',
        'Her leg got burnt in a fire.',
        'An accident caused by truck that hit her bus',
        2,
        0,
        15);
    FireProvider.of(context).fireBase.uploadQuestion(question, 15);
    question = new BookQuestion(
        'What  is the first thing the running team do when she came back after her accident',
        'They ignored her and didn’t talk to her',
        'They bought her a robotic leg',
        'They broguht her flowers to school',
        'They threw a party for her return',
        2,
        0,
        16);
    FireProvider.of(context).fireBase.uploadQuestion(question, 16);
    question = new BookQuestion(
        'Why does the main character would like to trade places with a girl that died in the accident. ',
        'Because she was in heaven',
        'Because she was a ghosts now and she can go trhough walls ',
        'Because she was an now angels',
        'Because she did not have to sufer for not being able to run',
        2,
        0,
        17);
    FireProvider.of(context).fireBase.uploadQuestion(question, 17);
    question = new BookQuestion(
        'Where was Jessica coming from when her accident happened?',
        'A competition',
        'A party',
        'A doctor\'s appointment',
        'A track meet',
        2,
        0,
        18);
    FireProvider.of(context).fireBase.uploadQuestion(question, 18);
    question = new BookQuestion(
        'How do the other students in her school react when she comes back after her accident',
        'The shower her with hugs and cheers',
        'They act like nothing has happened ',
        'They have cake and party for her',
        'They stare too much and ignore her',
        2,
        0,
        19);
    FireProvider.of(context).fireBase.uploadQuestion(question, 19);
    question = new BookQuestion('What is the protagonist best friend\'s name',
        'Laura', 'Jessica', 'Rosa', 'Fiona', 2, 0, 20);
    FireProvider.of(context).fireBase.uploadQuestion(question, 20);
    question = new BookQuestion(
        'What is the affliction the rosa suffers from',
        'Essential Tremor',
        'Huntington\'s Disease',
        'Rett Syndrome',
        'Cerebral Palsy',
        2,
        0,
        21);
    FireProvider.of(context).fireBase.uploadQuestion(question, 21);
    question = new BookQuestion(
        'Why is Jessica aprehensive about sitting with Rosa',
        'Because Rosa is mean to her',
        'Because she wants to sit closer to her best friend Fiona',
        'Because Rosa chews gum and that annoys Jessica',
        'Because she does not want to be seen as a handicapped',
        2,
        0,
        22);
    FireProvider.of(context).fireBase.uploadQuestion(question, 22);
    question = new BookQuestion(
        'Why do Jessica\'s parents have to fight insurance companies at court?',
        'They share Jessica\'s information without their consent',
        'They lost Jessica\'s documentation',
        'They only want to pay a portion of Jesicca\'s medical bills',
        'They refuse to pay Jessica\'s medical bills',
        2,
        0,
        23);
    FireProvider.of(context).fireBase.uploadQuestion(question, 23);
    question = new BookQuestion(
        'What does the team do to pay for Jessica\'s prostetic leg',
        'They ask their parents for money',
        'They sell valuables on Ebay',
        'They protest until the insurance pays for it',
        'They begging a fundraiser',
        2,
        0,
        24);
    FireProvider.of(context).fireBase.uploadQuestion(question, 24);
    question = new BookQuestion(
        'How does Jessica and Rosa get to know eachother better',
        'By hanging out after school',
        'By starting an afterschool club',
        'By teaming up for a class project',
        'By passing notes in class',
        2,
        0,
        25);
    FireProvider.of(context).fireBase.uploadQuestion(question, 25);
    question = new BookQuestion(
        'What is one of the biggest health concerns Jessica\'s parents have during her recovery',
        'Jessica forgets to take her medications',
        'Jessica is not doing rehabilitation exercizes',
        'Jessica\'s medication may upset her stomach',
        'Jessica can develop medication dependency',
        2,
        0,
        26);
    FireProvider.of(context).fireBase.uploadQuestion(question, 26);
    question = new BookQuestion('Which leg did Jessica loose in the accident',
        'Right ', 'Both', 'None she lost an arm', 'Left', 2, 0, 27);
    FireProvider.of(context).fireBase.uploadQuestion(question, 27);
    question = new BookQuestion(
        'What is the name of the town Jessica lives in',
        'VanDraaneen',
        'Carlisleville',
        'Vance',
        'None they do not name in the book',
        2,
        0,
        28);
    FireProvider.of(context).fireBase.uploadQuestion(question, 28);
    question = new BookQuestion(
        'How do they call the United States in this book? ',
        'The United States',
        'The country',
        'The United Republic',
        'The republic',
        3,
        0,
        29);
    FireProvider.of(context).fireBase.uploadQuestion(question, 29);
    question = new BookQuestion('What is June family name', 'Laris', 'Paris',
        'Day', 'Iparis', 3, 0, 30);
    FireProvider.of(context).fireBase.uploadQuestion(question, 30);
    question = new BookQuestion('What is June\'s brother name', 'Matias',
        'Matt', 'Mathew', 'Metias', 3, 0, 31);
    FireProvider.of(context).fireBase.uploadQuestion(question, 31);
    question = new BookQuestion('Where is plot set?', 'San Francisco',
        'San Diego', 'Long Beach', 'Los Angeles', 3, 0, 32);
    FireProvider.of(context).fireBase.uploadQuestion(question, 32);
    question = new BookQuestion(
        'What was the name of the rebel group portrayed in this book?',
        'The Giants',
        'The chiefs',
        'The nationalists',
        'The patriots',
        3,
        0,
        33);
    FireProvider.of(context).fireBase.uploadQuestion(question, 33);
    question = new BookQuestion('How old is June when the book starts', '14',
        '12', '16', '15', 3, 0, 34);
    FireProvider.of(context).fireBase.uploadQuestion(question, 34);
    question = new BookQuestion(
        'How well does June do on her Trial',
        'She flunks it',
        'She does at the top of her class',
        'She passes it',
        'She gets a perfect score',
        3,
        0,
        35);
    FireProvider.of(context).fireBase.uploadQuestion(question, 35);
    question = new BookQuestion(
        'Why are June parents not able to guide her?',
        'They have gone in a very long vacation',
        'They disapeared years ago',
        'They are pretty detached parents',
        'They died in a crash ',
        3,
        0,
        36);
    FireProvider.of(context).fireBase.uploadQuestion(question, 36);
    question = new BookQuestion(
        'What was June\'s brother doing when he was killed?',
        'Attacking a rebel camp',
        'He was in a super secret mission',
        'He was in his house playing first person shooters',
        'Guarding a hospital',
        3,
        0,
        37);
    FireProvider.of(context).fireBase.uploadQuestion(question, 37);
    question = new BookQuestion(
        'What caused Day to start his criminal life?',
        'He was abandoned by his dad',
        'Nothing, he was just born that way',
        'He wanted to be the most famous criminal in the Republic',
        'His dad was beaten and he failed his Trial',
        3,
        0,
        38);
    FireProvider.of(context).fireBase.uploadQuestion(question, 38);
    question = new BookQuestion(
        'Where was Day sent after he was caught? ',
        'A rehabilitation center',
        'Boarding school for boys',
        'A Juvenile Detention Facility',
        'The work camps',
        3,
        0,
        39);
    FireProvider.of(context).fireBase.uploadQuestion(question, 39);
    question = new BookQuestion(
        'What I sthe name of the other nation in war with the Republic',
        'The Seatlements',
        'The Protectorade',
        'The Annexed Territories',
        'The Colonies',
        3,
        0,
        40);
    FireProvider.of(context).fireBase.uploadQuestion(question, 40);
    question = new BookQuestion(
        'What were the work camps?',
        'A farm were criminals worked',
        'A facilty for experimentation',
        'A military training facility',
        'A lab that experimented with children',
        3,
        0,
        41);
    FireProvider.of(context).fireBase.uploadQuestion(question, 41);
    question = new BookQuestion('What was taken from Day in the camps?',
        'Money', 'A Watch ', 'Finger', 'Samples', 3, 0, 42);
    FireProvider.of(context).fireBase.uploadQuestion(question, 42);
    question = new BookQuestion(
        'How did Day feel about the Republic?',
        'He was indifferent',
        'He liked them',
        'He did not agree with them',
        'He hated them',
        3,
        0,
        43);
    FireProvider.of(context).fireBase.uploadQuestion(question, 43);
    question = new BookQuestion(
        'How is day connected to Metias death?',
        'He was haging out with Metias when he was killed',
        'He was spying on Metias the day he was killed',
        'He did not have any connection to Metias death',
        'He was harrasing the republic buildings when Metias was killed',
        3,
        0,
        44);
    FireProvider.of(context).fireBase.uploadQuestion(question, 44);
    question = new BookQuestion(
        'How do Day and June meet?',
        'June rescues Day from a fight outside the military college',
        'June and Day are paired in the military college',
        'June goes out in a stroll to the slums and asks Day for directions',
        'Day rescues June from a fight in the slums',
        3,
        0,
        45);
    FireProvider.of(context).fireBase.uploadQuestion(question, 45);
    question = new BookQuestion(
        'What is the main motivation for June to seek Day?',
        'She is in love with him',
        'Day is a wanted criminal',
        'She was instructed to find him, but she doesn’t know why',
        'To avenge her brother\'s death',
        3,
        0,
        46);
    FireProvider.of(context).fireBase.uploadQuestion(question, 46);
    question = new BookQuestion(
        'When and where was the book story set?',
        'England during World War I',
        'The UK during World War I',
        'Scotland during World War II ',
        'England during World War II',
        0,
        0,
        47);
    FireProvider.of(context).fireBase.uploadQuestion(question, 47);
    question = new BookQuestion('How old was Ada when the book starts', '11',
        '12', 'She was a teenager', '10', 0, 0, 48);
    FireProvider.of(context).fireBase.uploadQuestion(question, 48);
    question = new BookQuestion(
        'Why does Ada run away from home?',
        'Because her mom did not feed her',
        'Because her mom was never home',
        'Because her family was annoying',
        'Because her mom was abusive',
        0,
        0,
        49);
    FireProvider.of(context).fireBase.uploadQuestion(question, 49);
    question = new BookQuestion(
        'What is the issue with Ada\'s limb?',
        'She was born with a skew foot',
        'She was born with Cavus foot',
        'She was born with Juvenile Bunion',
        'She was born with a clubfoot',
        0,
        0,
        50);
    FireProvider.of(context).fireBase.uploadQuestion(question, 50);
    question = new BookQuestion(
        'How did Ada interacted with the world when she lived with her mom?',
        'She looked outside through a hole in the wall',
        'She went out regurlaly with her mom',
        'She looked outside through the door\'s peek hole',
        'She was only able to look at it from her window',
        0,
        0,
        51);
    FireProvider.of(context).fireBase.uploadQuestion(question, 51);
    question = new BookQuestion(
        'What are the shores Ada must do while she lives with her mom?',
        'Cooking and doing her brothers homework',
        'Cleaning, cooking and taking care of her sister',
        'Cooking, cleaning and taking care of their pet',
        'Cooking, Cleaning and caring for her brother',
        0,
        0,
        52);
    FireProvider.of(context).fireBase.uploadQuestion(question, 52);
    question = new BookQuestion(
        'What is Ada secretly practicing while her mom is not home?',
        'To Read',
        'To write',
        'to walk and read',
        'To walk',
        0,
        0,
        53);
    FireProvider.of(context).fireBase.uploadQuestion(question, 53);
    question = new BookQuestion(
        'What happens to the children of London when the war breaks out?',
        'They are send to family abroad',
        'They are sent to the battlefield',
        'They are kept in London',
        'They are take to the country side',
        0,
        0,
        54);
    FireProvider.of(context).fireBase.uploadQuestion(question, 54);
    question = new BookQuestion(
        'Who does Ada take with her during the evacuation?',
        'Her cat',
        'Her dog',
        'Her mom and brother',
        'Her brother',
        0,
        0,
        55);
    FireProvider.of(context).fireBase.uploadQuestion(question, 55);
    question = new BookQuestion(
        'What is the name of the village Ada ends up at during the evacuation',
        'The Village of Burnsall',
        'The Village of Clovely',
        'The Village of Kingham',
        'The Village of Kent',
        0,
        0,
        56);
    FireProvider.of(context).fireBase.uploadQuestion(question, 56);
    question = new BookQuestion(
        'What is preventing Ada and her brother for being taken once they get to the countryside?',
        'People think they are uneducated',
        'People think they are going to eat all their food',
        'People thik they might steal',
        'People think they are dirty',
        0,
        0,
        57);
    FireProvider.of(context).fireBase.uploadQuestion(question, 57);
    question = new BookQuestion(
        'What is the name of the owner of the house where Ada and her brother end up staying?',
        'Susan Smith',
        'Miss Smythe',
        'Miss Smyth',
        'Miss Smith',
        0,
        0,
        58);
    FireProvider.of(context).fireBase.uploadQuestion(question, 58);
    question = new BookQuestion(
        'What is the reason Ada and her Jamie are allowed into Susan Smith\'s home?',
        'They are related ',
        'They promised to help with shores',
        'They were adopted by the Smith family',
        'They had nowhere else to go',
        0,
        0,
        59);
    FireProvider.of(context).fireBase.uploadQuestion(question, 59);
    question = new BookQuestion(
        'How does the doctor suggest should be done to help Ada fix her foot?',
        'Treatment',
        'It will fix on its own with time',
        'None of these answers is right',
        'Surgery',
        0,
        0,
        60);
    FireProvider.of(context).fireBase.uploadQuestion(question, 60);
    question = new BookQuestion(
        'What is preventing the doctor from helping Ada with her foot?',
        'He did not have resources to help her',
        'He did not know how to fix her foot',
        'Ada could not pay the doctor\'s fees',
        'Parent permission',
        0,
        0,
        61);
    FireProvider.of(context).fireBase.uploadQuestion(question, 61);
    question = new BookQuestion(
        'What do Ada and her brother learn while they stay at Miss Smith house',
        'Read and write',
        'Math and science',
        'Read and ride a pony',
        'Read, write and ride a pony',
        0,
        0,
        62);
    FireProvider.of(context).fireBase.uploadQuestion(question, 62);
    question = new BookQuestion(
        'How helps Ada  walk everywhere in the countryside?',
        'She uses crutches she won in a raffle',
        'She uses crutches her mom sent her',
        'She uses crutches she bough with her savings',
        'She uses crutches Miss smith gave her',
        0,
        0,
        63);
    FireProvider.of(context).fireBase.uploadQuestion(question, 63);
    question = new BookQuestion(
        'How did Ada and Jamie help Miss Smith?',
        'They help help her with shores around the house',
        'They help her take care of the pony',
        'They just hang out with her, they don\'t do much else',
        'They help her cope with her depression',
        0,
        0,
        64);
    FireProvider.of(context).fireBase.uploadQuestion(question, 64);
    question = new BookQuestion(
        'How old was Knud Pedersen when Hitler invaded Denmark?',
        '13',
        '12',
        '15',
        '14',
        5,
        0,
        65);
    FireProvider.of(context).fireBase.uploadQuestion(question, 65);
    question = new BookQuestion(
        'What was the name of the town the protagonist lived?',
        'Svendborg',
        'Aalborg',
        'Odesa',
        'Odense',
        5,
        0,
        66);
    FireProvider.of(context).fireBase.uploadQuestion(question, 66);
    question = new BookQuestion(
        'Why was Knud embarrised about in the time of the invasion?',
        'He was embarrised that Danish authorities fought too hard and sacrificed to many innocents',
        'He was embarrised because the Danish people supported Hitler',
        'He was not embarrised about anything',
        'He was embarrised about the Danish authorities surrendering so easily',
        5,
        0,
        67);
    FireProvider.of(context).fireBase.uploadQuestion(question, 67);
    question = new BookQuestion(
        'What trigger Knud involvement in politics',
        'Hitlers invasion of europe',
        'Hitlers invasion of Odesa',
        'Hitlers invassion of Copenhagen',
        'Hitler\'s invassion of Denmark',
        5,
        0,
        68);
    FireProvider.of(context).fireBase.uploadQuestion(question, 68);
    question = new BookQuestion(
        'What is the name of the resistance group Knud\'s brother starts in Odense?',
        'The RALPH club',
        'The Churchill Club',
        'They did not form a club',
        'The RAF club',
        5,
        0,
        69);
    FireProvider.of(context).fireBase.uploadQuestion(question, 69);
    question = new BookQuestion(
        'Knuds and Jens savotage club does what to the german army?',
        'Cuts phones wires',
        'Vandalize signs',
        'None of this',
        'Both Cuts phones wires and Vandalize signs',
        5,
        0,
        70);
    FireProvider.of(context).fireBase.uploadQuestion(question, 70);
    question = new BookQuestion(
        'To which city does Knud\'s father get reasigned to?',
        'Helsingborg',
        'Silkeborg',
        'Svendborg',
        'Aalborg',
        5,
        0,
        71);
    FireProvider.of(context).fireBase.uploadQuestion(question, 71);
    question = new BookQuestion(
        'What is the name of the resistance group Knud\'s brother starts at Aalborg?',
        'The RALF club',
        'The Churchill gentlemen',
        'They do not form a club in this city',
        'The Churchill Club',
        5,
        0,
        72);
    FireProvider.of(context).fireBase.uploadQuestion(question, 72);
    question = new BookQuestion(
        'What was Knuds and parents involvement in the Churchill Club when he started it?',
        'They did not give him the idea, but they support it',
        'They warned knud and Jens that startign a club against the Germans was dangerous',
        'They gave him the idea',
        'They did not participate because the did not know. The club was a secret',
        5,
        0,
        73);
    FireProvider.of(context).fireBase.uploadQuestion(question, 73);
    question = new BookQuestion(
        'Why was Hitler interested in Denmark?',
        'Denmark was a fertile land',
        'Denmark location was estrategic during the war',
        'Hitler saw Danish as model Aryans',
        'All these options',
        5,
        0,
        74);
    FireProvider.of(context).fireBase.uploadQuestion(question, 74);
    question = new BookQuestion(
        'What was Knud\'s dad Job?',
        'He was a politian',
        'He was a bussines owner',
        'He worked for the nazis',
        'He was a preacher',
        5,
        0,
        75);
    FireProvider.of(context).fireBase.uploadQuestion(question, 75);
    question = new BookQuestion(
        'How did danish people showed their patriotism during the invassion?',
        'Buying "kings badges"',
        'Refusing to speak german at school',
        'Speaking only Danish at school',
        'All these options',
        5,
        0,
        76);
    FireProvider.of(context).fireBase.uploadQuestion(question, 76);
    question = new BookQuestion(
        'All danish people rejected the germans',
        'No, some bussines supported the germans by giving them food',
        'Yes, all danish people revolted against the germans',
        'Yes, the authorities and the whole country erjected the german invasion',
        'No, some bussines helped the germans providing weapons and housing',
        5,
        0,
        77);
    FireProvider.of(context).fireBase.uploadQuestion(question, 77);
    question = new BookQuestion(
        'Knud and Jen are prohibited from joining Boyscouts by',
        'Their mom',
        'Their mom and dad',
        'The germans',
        'Their dad',
        5,
        0,
        78);
    FireProvider.of(context).fireBase.uploadQuestion(question, 78);
    question = new BookQuestion(
        'Where is the story set at the beginning of the book?',
        'Florida',
        'All of these',
        'Chicago',
        'Gainesville',
        6,
        0,
        79);
    FireProvider.of(context).fireBase.uploadQuestion(question, 79);
    question = new BookQuestion('What age was Malu at the begging of the story',
        '11', '10', '13', '12', 6, 0, 80);
    FireProvider.of(context).fireBase.uploadQuestion(question, 80);
    question = new BookQuestion(
        'What etnicity was Malu?',
        'Puerto Rican-American',
        'Nicaraguan-American',
        'Salvatorian-American',
        'Mexican-American',
        6,
        0,
        81);
    FireProvider.of(context).fireBase.uploadQuestion(question, 81);
    question = new BookQuestion(
        'What bussines did Malu\'s father have in Gainesvile?',
        'A taco shop',
        'A restaurant',
        'A book shop',
        'A record store',
        6,
        0,
        82);
    FireProvider.of(context).fireBase.uploadQuestion(question, 82);
    question = new BookQuestion('Where does Malu\'s fmaily relocates to?',
        'Alabama', 'Gainesville', 'New York', 'Chicago', 6, 0, 83);
    FireProvider.of(context).fireBase.uploadQuestion(question, 83);
    question = new BookQuestion(
        'What type of activity does Malu start in Chicago?',
        'A reading club',
        'A cooking club',
        'A quartet',
        'A punk band',
        6,
        0,
        84);
    FireProvider.of(context).fireBase.uploadQuestion(question, 84);
    question = new BookQuestion(
        'Why does Malu refers to her mom as the Super Mexican?',
        'Because she is a mexican wrestler champion',
        'Because she is secretly a super hero',
        'Because she think her mom is amazingly patriotic',
        'Because of her strict Mexican traditions',
        6,
        0,
        85);
    FireProvider.of(context).fireBase.uploadQuestion(question, 85);
    question = new BookQuestion(
        'What does Malu\'s dad gives her mom on their anniversary?',
        'A big huge bouquet of flowers',
        'Chocolates',
        'A diamond ring',
        'Nothing, they are divorced',
        6,
        0,
        86);
    FireProvider.of(context).fireBase.uploadQuestion(question, 86);
    question = new BookQuestion(
        'What does Malu\'s Mom favorite punk band?',
        'The ramones',
        'Blink-182',
        'Green day',
        'None, she despises rock',
        6,
        0,
        87);
    FireProvider.of(context).fireBase.uploadQuestion(question, 87);
    question = new BookQuestion(
        'What typical mexican dish ingredient does Malu dislike?',
        'Avocado and cilantro',
        'Salsa and chips',
        'tacos and burritos',
        'Cilantro and spicy peppers',
        6,
        0,
        88);
    FireProvider.of(context).fireBase.uploadQuestion(question, 88);
    question = new BookQuestion(
        'What prompts Malu to move to Chicago?',
        'Nothing she never moves there',
        'Her mom got a job as a school principle',
        'Her dad tell her to go',
        'Her mom got a teaching position there',
        6,
        0,
        89);
    FireProvider.of(context).fireBase.uploadQuestion(question, 89);
    question = new BookQuestion(
        'What excites Malu the most about moving to chicago?',
        'She wants to be able to attend lots of punk concerts',
        'Her new school will be awesome, they have a punk rock band',
        'Some of her friends are moving there. ',
        'Nothing, she does not want  to move there',
        6,
        0,
        90);
    FireProvider.of(context).fireBase.uploadQuestion(question, 90);
    question = new BookQuestion(
        'What surprises Malu once she arrives at her new school',
        'The small number of hispanic kids in the school',
        'The large ammount of hispanic teachers in the school',
        'The small number of hispanic teachers in the school',
        'The large ammount of hispanic students',
        6,
        0,
        91);
    FireProvider.of(context).fireBase.uploadQuestion(question, 91);
    question = new BookQuestion(
        'What is the name of the school Malu joins once she gets to Chicago?',
        'La Casa Middle School',
        'La Pose Middle School',
        'Posadon Middle School',
        'Posada Middle School',
        6,
        0,
        92);
    FireProvider.of(context).fireBase.uploadQuestion(question, 92);
    question = new BookQuestion(
        'What is Malu\'s hobby besides Punk Rock?',
        'Writing articles for magazines',
        'Making illustrations for Magazines',
        'None of these',
        'Making Zines',
        6,
        0,
        93);
    FireProvider.of(context).fireBase.uploadQuestion(question, 93);
    question = new BookQuestion(
        'What did Malu put on her mom\'s purse to express her disagrement with moving to Chicago?',
        'A zine talking about the benefits of living in Gainesville',
        'A note asking her mom to let her stay with her dad',
        'None of these, she did not complain',
        'A zine declaring "There is no place like Home"',
        6,
        0,
        94);
    FireProvider.of(context).fireBase.uploadQuestion(question, 94);
    question = new BookQuestion(
        'When does the story takes place?',
        'After world war I',
        'None of these, it was not clear',
        'In Germany',
        'After world war II',
        7,
        0,
        95);
    FireProvider.of(context).fireBase.uploadQuestion(question, 95);
    question = new BookQuestion('Where did Gerta live?', 'West Germany',
        'Germany', 'None of these', 'East Germany', 7, 0, 96);
    FireProvider.of(context).fireBase.uploadQuestion(question, 96);
    question = new BookQuestion(
        'What are the Grenzers?',
        'The city firefighters',
        'The city police',
        'All of the options',
        'The border police',
        7,
        0,
        97);
    FireProvider.of(context).fireBase.uploadQuestion(question, 97);
    question = new BookQuestion(
        'What did Gerta\'s father keep from her?',
        'He was a govertment supported',
        'He was criminal',
        'None of these. He had nothing to hide',
        'He was critical of the government',
        7,
        0,
        98);
    FireProvider.of(context).fireBase.uploadQuestion(question, 98);
    question = new BookQuestion(
        'How long did it take to erect the Berlin wall?',
        '1 day',
        '2 days',
        '1 week',
        '1 night',
        7,
        0,
        99);
    FireProvider.of(context).fireBase.uploadQuestion(question, 99);
    question = new BookQuestion(
        'Why is Gerta\'s father separated from his family?',
        'Because he was at the other side of the wall when it was erected',
        'Because his job required him to travel abroad',
        'All of these',
        'Because he was seeking employment on West Berlin',
        7,
        0,
        100);
    FireProvider.of(context).fireBase.uploadQuestion(question, 100);
    question = new BookQuestion(
        'Gerta\'s mother is not supportive of',
        'Criminals',
        'Government officials ',
        'Protesters and Sabotours',
        'Dissidents or protesters',
        7,
        0,
        101);
    FireProvider.of(context).fireBase.uploadQuestion(question, 101);
    question = new BookQuestion('Gerta\'s side of the wall government was',
        'Socialist', 'Democracy', 'Authoritarian', 'Communist', 7, 0, 102);
    FireProvider.of(context).fireBase.uploadQuestion(question, 102);
    question = new BookQuestion(
        'Gerta is accompanied by her mother and..',
        'Her dad',
        'Her brother Fritz and her brother Dominic',
        'Her brother Dominic',
        'her brother Fritz',
        7,
        0,
        103);
    FireProvider.of(context).fireBase.uploadQuestion(question, 103);
    question = new BookQuestion(
        'Did Gerta and her mom kept sending secret letters to her dad?',
        'Yes, They got letters with money from her dad',
        'Yes, They sent letters asking for help, which they received',
        'No, they did not send letter they sent telegrams.',
        'No, they could not communicate or receive support from West Germany',
        7,
        0,
        104);
    FireProvider.of(context).fireBase.uploadQuestion(question, 104);
    question = new BookQuestion(
        'What ammenity or ammenities from West Germany does Fritz crave?',
        'The Beatles albums',
        'Sodas',
        'Being able to dress as he pleases',
        'All of these',
        7,
        0,
        105);
    FireProvider.of(context).fireBase.uploadQuestion(question, 105);
    question = new BookQuestion(
        'What\'s is the main subject of the book?',
        'Family disputes',
        'Family ideas',
        'Family problems',
        'Family relations',
        7,
        0,
        106);
    FireProvider.of(context).fireBase.uploadQuestion(question, 106);
    question = new BookQuestion(
        'What did Gerta think when she heard all the noise the morning of August 13 1961? ',
        'She thought her country was being invaded',
        'She thought war was starting again',
        'None of these, there was no noise that morning',
        'She thought an air raid was happening',
        7,
        0,
        107);
    FireProvider.of(context).fireBase.uploadQuestion(question, 107);
    question = new BookQuestion(
        'Which neighboor warned Gerta\'s family about the government',
        'Herr Krazzer',
        'Herr Heinz',
        'Herr Kraisler',
        'Herr Krause',
        7,
        0,
        108);
    FireProvider.of(context).fireBase.uploadQuestion(question, 108);
    question = new BookQuestion('Which city did Gerta live in?', 'Dresden',
        'Munich', 'Hamburg', 'Berlin', 7, 0, 109);
    FireProvider.of(context).fireBase.uploadQuestion(question, 109);
    question = new BookQuestion(
        'When did gerta realized that something really bad was going to happen?',
        'the day before the fence was buildt during lunch',
        'Two days before the fence was erected during lunch',
        'She did not suspect anything was going to happen',
        'Two days before the fence was erected, during dinner',
        7,
        0,
        110);
    FireProvider.of(context).fireBase.uploadQuestion(question, 110);
    question = new BookQuestion('What was the name of the secret police?',
        'Stace', 'Stackers', 'Slavers', 'Staci', 7, 0, 111);
    FireProvider.of(context).fireBase.uploadQuestion(question, 111);
    question = new BookQuestion(
        'Who did Herr Krause share his appartment with? ',
        'With his children',
        'With his Mom',
        'With his parents',
        'With his wife',
        7,
        0,
        112);
    FireProvider.of(context).fireBase.uploadQuestion(question, 112);
    question = new BookQuestion(
        'Which goverment was controlling East Germany',
        'The US, Washington',
        'No government was influnencing East Germany',
        'West Germany',
        'Russia, Moscow',
        7,
        0,
        113);
    FireProvider.of(context).fireBase.uploadQuestion(question, 113);
    question = new BookQuestion(
        'Who in Gerta\'s family did not want to go to East Germany before the wall was buildt',
        'Her dad ',
        'Her brothers',
        'Her mom and dad',
        'Her mom',
        7,
        0,
        114);
    FireProvider.of(context).fireBase.uploadQuestion(question, 114);
    question = new BookQuestion(
        'Why did Gerta\'s mom did not want to leaver for West Germany',
        'Because she did not want to live in a refuge camp',
        'She did not want to beg for food',
        'She did not want to leave her mom behind',
        'All of these',
        7,
        0,
        115);
    FireProvider.of(context).fireBase.uploadQuestion(question, 115);
    question = new BookQuestion(
        'Why did Fritz Offered to accompany his dad to the trip to West Germany',
        'Because he wanted to be able to see a movie he was not able to see on East Germany',
        'Because he was very found of his dad',
        'Because his mom sugested it',
        'Because he was planning to buy magazines to sell when he came back',
        7,
        0,
        116);
    FireProvider.of(context).fireBase.uploadQuestion(question, 116);
    question = new BookQuestion(
        'What was Gerta\'s favorite song before she went to bed',
        'The Farmer in the Farm',
        'The Farmer and his Band',
        'The Farmer in the March',
        'The Farmer in March',
        7,
        0,
        117);
    FireProvider.of(context).fireBase.uploadQuestion(question, 117);
    question = new BookQuestion(
        'Why did Fritz think his dad was not going to be allowed back?',
        'Because the government thought he was a criminal',
        'Because the police would not let anyone back that had left East Germany',
        'None of these, his dad came back',
        'Because the police thouhgt his dad was part of the resistance',
        7,
        0,
        118);
    FireProvider.of(context).fireBase.uploadQuestion(question, 118);
    question = new BookQuestion(
        'What did people called the Sunday after the wall was buildt?',
        'Wired Sunday',
        'Pray Sunday',
        'Sad Sunday',
        'Barbed Wire Sunday',
        7,
        0,
        119);
    FireProvider.of(context).fireBase.uploadQuestion(question, 119);
    question = new BookQuestion(
        'How did the Grenzers ruined West Germany protesters pictures?',
        'They crashed the cameras',
        'The threw water at the cameras',
        'They made rude gestures at the cameras',
        'They shone sun light to the lenses with mirrors',
        7,
        0,
        120);
    FireProvider.of(context).fireBase.uploadQuestion(question, 120);
    question = new BookQuestion(
        'What was the first upgrade to fence?',
        'The Government installed security cameras',
        'The government installed an electricity fence',
        'The Government added more guards',
        'The government made it into a concrete wall',
        7,
        0,
        121);
    FireProvider.of(context).fireBase.uploadQuestion(question, 121);
    question = new BookQuestion(
        'What did the Government of East germany called those who fled ?',
        'Weakminded',
        'Desserters',
        'They did not make any comments',
        'Desserters and weak minded',
        7,
        0,
        122);
    FireProvider.of(context).fireBase.uploadQuestion(question, 122);
    question = new BookQuestion(
        'What did the government of East germany called people in West Germany ',
        'Imperialist',
        'Capitalist',
        'All of these',
        'Fascist',
        7,
        0,
        123);
    FireProvider.of(context).fireBase.uploadQuestion(question, 123);
    question = new BookQuestion(
        'What did the Pionners teach Gerta?',
        'Freedom was overrated',
        'Individuality was bad',
        'Avoid evil influences like the beatles and fancy clothes',
        'All of these',
        7,
        0,
        124);
    FireProvider.of(context).fireBase.uploadQuestion(question, 124);
    question = new BookQuestion(
        'Why coundt Gerta\'s family called her dad over the phone?',
        'The government prohibited calls to West Germany ',
        'They did not know her dad\'s number',
        'None of these',
        'The government cut the phone lines to the west',
        7,
        0,
        125);
    FireProvider.of(context).fireBase.uploadQuestion(question, 125);
    question = new BookQuestion(
        'Why is Timothy required to write his memories',
        'As a punishement for stealing food',
        'As a punishment for stealing medicine',
        'He enjoyed keeping track of his daily life',
        'As a punishment for stealing wallet',
        8,
        0,
        126);
    FireProvider.of(context).fireBase.uploadQuestion(question, 126);
    question = new BookQuestion(
        'What\'s the name of the Timothy probation Officer',
        'Jameson',
        'Janis',
        'John',
        'James',
        8,
        0,
        127);
    FireProvider.of(context).fireBase.uploadQuestion(question, 127);
    question = new BookQuestion(
        'Why does Timothy steal?',
        'He steals because he needs money for a new video game',
        'He steals because he needs money for food',
        'He steals because he is bored and he wants some exciment in his life',
        'He steals to buy medication for his sick brother',
        8,
        0,
        128);
    FireProvider.of(context).fireBase.uploadQuestion(question, 128);
    question = new BookQuestion(
        'What is Levi health problem?',
        'He has cancer',
        'He is got the flue',
        'He is got brochiatis',
        'He suffers from trachea problems',
        8,
        0,
        129);
    FireProvider.of(context).fireBase.uploadQuestion(question, 129);
    question = new BookQuestion(
        'How much money do Levi\'s medication cost every month?',
        '1000',
        '1455',
        '1400',
        '1500',
        8,
        0,
        130);
    FireProvider.of(context).fireBase.uploadQuestion(question, 130);
    question = new BookQuestion(
        'What happens to Levi at the end of winter',
        'He has to go the hospital',
        'He is checked into intensive care',
        'All of these',
        'He becomes very ill ',
        8,
        0,
        131);
    FireProvider.of(context).fireBase.uploadQuestion(question, 131);
    question = new BookQuestion(
        'How old is Timothy?', '11', '10', '13', '12', 8, 0, 132);
    FireProvider.of(context).fireBase.uploadQuestion(question, 132);
    question = new BookQuestion(
        'Timothy is labeled by the court to be',
        'A jubvenile criminal',
        'Innocent ',
        'Guilty of a crime',
        'An adjudicated delinquent',
        8,
        0,
        133);
    FireProvider.of(context).fireBase.uploadQuestion(question, 133);
    question = new BookQuestion(
        'How long is Timothy asked to write a journal?',
        '7 days a week for a year',
        '6 days a week for two years',
        'One year',
        '6 days a week for one year',
        8,
        0,
        134);
    FireProvider.of(context).fireBase.uploadQuestion(question, 134);
    question = new BookQuestion(
        'How did Timothy\'s dad felt when he stole the wallet',
        'Very disspointed ',
        'Proud of him, His dad was a renound criminal himself',
        'Very sad because he could not help Timothy',
        'None of these, His dad left them before he stole the wallet',
        8,
        1,
        135);
    FireProvider.of(context).fireBase.uploadQuestion(question, 135);
  }
}

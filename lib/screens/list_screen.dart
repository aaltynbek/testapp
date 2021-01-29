import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:testapp/services/network_services.dart';
import 'package:testapp/services/storage_manager.dart';
import 'package:testapp/services/theme_manager.dart';

class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  List items = [
   {
      "itemId":"10056",
      "name":"IronMan",
      "image":"http://s8.hostingkartinok.com/uploads/images/2016/03/b70762d52599ffc44dc7539bf57baa1c.jpg",
      "description":"Iron Man is a superhero who wears a suit of armor. His alter ego is Tony Stark. He was created by Stan Lee, Jack Kirby and Larry Lieber for Marvel Comics in Tales of Suspense #39 in the year 1963 and appears in their comic books. He is also one of the main protagonists in the Marvel Cinematic Universe. In the movies and the earlier comic books, Tony Stark is a human. Outside the suit, he does not have any superpowers, however he has an enormous QI, in fact his intelligence gives to him the sufficient power instead of physycal superpowers. He made the suit himself, and nobody else can usually control it. Iron Man can fly and shoot beams from his hands using special technology called \"repulsors\" in his boots and gloves. He is not hurt by most weapons like guns and cannons. There are many versions of the Iron Man suit, because Stark keeps making improvements.In the later comic books, Stark took an experimental virus called \"STD\" which allowed him to control his suit with his mind and summon it wherever he was. Stark would eventually develop an armor that he could store in his body. This armor was known as the \"Bleeding Edge Model 37\".",
      "time":"1457018867393"
   },
   {
      "itemId":"10054",
      "name":"Deadpool",
      "image":"http://s8.hostingkartinok.com/uploads/images/2016/03/3d23f908f56428ac97840acae92c1f50.jpg",
      "description":"Deadpool (Wade Winston Wilson) is a fictional character appearing in American comic books published by Marvel Comics. Created by writer Fabian Nicieza and artist/writer Rob Liefeld, the character first appeared in The New Mutants #98 (cover-dated February 1991). Initially Deadpool was depicted as a supervillain when he made his first appearance in The New Mutants and later in issues of X-Force, but later evolved into his more recognizable antiheroic persona. Deadpool, whose real name is Wade Wilson, is a disfigured mercenary with the superhuman ability of an accelerated healing factor and physical prowess. The character is known as the \"Merc with a Mouth\" because of his tendency to talk and joke constantly, including breaking the fourth wall for humorous effect and running gags.The character's popularity has seen him featured in numerous forms of other media. In the 2004 series Cable & Deadpool, he refers to his own scarred appearance as \"Ryan Reynolds crossed with a Shar-Pei\" (though in the comic, Reynolds' name is misspelled as \"Renolds\".)Reynolds himself would eventually portray the character in the X-Men film series, appearing in X-Men Origins: Wolverine (2009), Deadpool (2016), and its sequel Deadpool 2 (2018). He is slated to continue playing the character in the Marvel Cinematic Universe.",
      "time":"1457018837658"
   },
   {
      "itemId":"10028",
      "name":"Thor",
      "image":"http://s8.hostingkartinok.com/uploads/images/2016/03/44819c5cf496a059797d43ffcab07508.jpg",
      "description":"Thor Odinson is the Asgardian God of Thunder, superhero, self-proclaimed protector of Earth and the king of Asgard. Thor made a name for himself as the mightiest warrior on his homeworld and subsequently became well known for his actions on Earth, which included acting as a founding member of the Avengers. He is the son of Odin Borson and Frigga, and the adopted brother of Loki Laufeyson. Thor wielded the mystical war hammer Mjölnir, which channeled his God of Thunder abilities until it was destroyed by his sister Hela. In an attempt to flee his sister, Thor found himself stranded on Sakaar where he was forced to be a champion in the Grandmaster's games. After escaping Sakaar, he brought about Ragnarök with the help of the Revengers and destroyed his home and Hela with it. He lead the Asgardian refugees away from the destruction in hunt for a new home.",
      "time":"1457018877305"
   },
   {
      "itemId":"10048",
      "name":"Hulk",
      "image":"http://s8.hostingkartinok.com/uploads/images/2016/03/dd54db9d3ea626ece12f4123d3b63306.jpg",
      "description":"The Hulk is a fictional superhero appearing in publications by the American publisher Marvel Comics. Created by writer Stan Lee and artist Jack Kirby, the character first appeared in the debut issue of The Incredible Hulk (May 1962). In his comic book appearances, the character is both the Hulk, a green-skinned, hulking and muscular humanoid possessing a vast degree of physical strength, and his alter ego Dr. Robert Bruce Banner, a physically weak, socially withdrawn, and emotionally reserved physicist, the two existing as independent personalities and resenting of the other. Following his accidental exposure to gamma rays saving the life of Rick Jones during the detonation of an experimental bomb, Banner is physically transformed into the Hulk when subjected to emotional stress, at or against his will, often leading to destructive rampages and conflicts that complicate Banner's civilian life. The Hulk's level of strength is normally conveyed as proportionate to his level of anger. Commonly portrayed as a raging savage, the Hulk has been represented with other personalities based on Banner's fractured psyche, from a mindless, destructive force, to a brilliant warrior, or genius scientist in his own right. Despite both Hulk and Banner's desire for solitude, the character has a large supporting cast, including Banner's lover Betty Ross, his best friend Rick Jones, his cousin She-Hulk, therapist and ally Doc Samson, and his co-founders of the superhero team the Avengers, etc. However, his uncontrollable power has brought him into conflict with his fellow heroes and others. Despite this he tries his best to do what's right while battling villains such as Leader, Abomination, Absorbing Man and more.",
      "time":"1457018788101"
   },
   {
      "itemId":"10056",
      "name":"IronMan",
      "image":"http://s8.hostingkartinok.com/uploads/images/2016/03/b70762d52599ffc44dc7539bf57baa1c.jpg",
      "description":"Iron Man is a superhero who wears a suit of armor. His alter ego is Tony Stark. He was created by Stan Lee, Jack Kirby and Larry Lieber for Marvel Comics in Tales of Suspense #39 in the year 1963 and appears in their comic books. He is also one of the main protagonists in the Marvel Cinematic Universe. In the movies and the earlier comic books, Tony Stark is a human. Outside the suit, he does not have any superpowers, however he has an enormous QI, in fact his intelligence gives to him the sufficient power instead of physycal superpowers. He made the suit himself, and nobody else can usually control it. Iron Man can fly and shoot beams from his hands using special technology called \"repulsors\" in his boots and gloves. He is not hurt by most weapons like guns and cannons. There are many versions of the Iron Man suit, because Stark keeps making improvements.In the later comic books, Stark took an experimental virus called \"STD\" which allowed him to control his suit with his mind and summon it wherever he was. Stark would eventually develop an armor that he could store in his body. This armor was known as the \"Bleeding Edge Model 37\".",
      "time":"1457018867393"
   },
   {
      "itemId":"10054",
      "name":"Deadpool",
      "image":"http://s8.hostingkartinok.com/uploads/images/2016/03/3d23f908f56428ac97840acae92c1f50.jpg",
      "description":"Deadpool (Wade Winston Wilson) is a fictional character appearing in American comic books published by Marvel Comics. Created by writer Fabian Nicieza and artist/writer Rob Liefeld, the character first appeared in The New Mutants #98 (cover-dated February 1991). Initially Deadpool was depicted as a supervillain when he made his first appearance in The New Mutants and later in issues of X-Force, but later evolved into his more recognizable antiheroic persona. Deadpool, whose real name is Wade Wilson, is a disfigured mercenary with the superhuman ability of an accelerated healing factor and physical prowess. The character is known as the \"Merc with a Mouth\" because of his tendency to talk and joke constantly, including breaking the fourth wall for humorous effect and running gags.The character's popularity has seen him featured in numerous forms of other media. In the 2004 series Cable & Deadpool, he refers to his own scarred appearance as \"Ryan Reynolds crossed with a Shar-Pei\" (though in the comic, Reynolds' name is misspelled as \"Renolds\".)Reynolds himself would eventually portray the character in the X-Men film series, appearing in X-Men Origins: Wolverine (2009), Deadpool (2016), and its sequel Deadpool 2 (2018). He is slated to continue playing the character in the Marvel Cinematic Universe.",
      "time":"1457018837658"
   },
   {
      "itemId":"10028",
      "name":"Thor",
      "image":"http://s8.hostingkartinok.com/uploads/images/2016/03/44819c5cf496a059797d43ffcab07508.jpg",
      "description":"Thor Odinson is the Asgardian God of Thunder, superhero, self-proclaimed protector of Earth and the king of Asgard. Thor made a name for himself as the mightiest warrior on his homeworld and subsequently became well known for his actions on Earth, which included acting as a founding member of the Avengers. He is the son of Odin Borson and Frigga, and the adopted brother of Loki Laufeyson. Thor wielded the mystical war hammer Mjölnir, which channeled his God of Thunder abilities until it was destroyed by his sister Hela. In an attempt to flee his sister, Thor found himself stranded on Sakaar where he was forced to be a champion in the Grandmaster's games. After escaping Sakaar, he brought about Ragnarök with the help of the Revengers and destroyed his home and Hela with it. He lead the Asgardian refugees away from the destruction in hunt for a new home.",
      "time":"1457018877305"
   },
   {
      "itemId":"10048",
      "name":"Hulk",
      "image":"http://s8.hostingkartinok.com/uploads/images/2016/03/dd54db9d3ea626ece12f4123d3b63306.jpg",
      "description":"The Hulk is a fictional superhero appearing in publications by the American publisher Marvel Comics. Created by writer Stan Lee and artist Jack Kirby, the character first appeared in the debut issue of The Incredible Hulk (May 1962). In his comic book appearances, the character is both the Hulk, a green-skinned, hulking and muscular humanoid possessing a vast degree of physical strength, and his alter ego Dr. Robert Bruce Banner, a physically weak, socially withdrawn, and emotionally reserved physicist, the two existing as independent personalities and resenting of the other. Following his accidental exposure to gamma rays saving the life of Rick Jones during the detonation of an experimental bomb, Banner is physically transformed into the Hulk when subjected to emotional stress, at or against his will, often leading to destructive rampages and conflicts that complicate Banner's civilian life. The Hulk's level of strength is normally conveyed as proportionate to his level of anger. Commonly portrayed as a raging savage, the Hulk has been represented with other personalities based on Banner's fractured psyche, from a mindless, destructive force, to a brilliant warrior, or genius scientist in his own right. Despite both Hulk and Banner's desire for solitude, the character has a large supporting cast, including Banner's lover Betty Ross, his best friend Rick Jones, his cousin She-Hulk, therapist and ally Doc Samson, and his co-founders of the superhero team the Avengers, etc. However, his uncontrollable power has brought him into conflict with his fellow heroes and others. Despite this he tries his best to do what's right while battling villains such as Leader, Abomination, Absorbing Man and more.",
      "time":"1457018788101"
   },
   {
      "itemId":"10056",
      "name":"IronMan",
      "image":"http://s8.hostingkartinok.com/uploads/images/2016/03/b70762d52599ffc44dc7539bf57baa1c.jpg",
      "description":"Iron Man is a superhero who wears a suit of armor. His alter ego is Tony Stark. He was created by Stan Lee, Jack Kirby and Larry Lieber for Marvel Comics in Tales of Suspense #39 in the year 1963 and appears in their comic books. He is also one of the main protagonists in the Marvel Cinematic Universe. In the movies and the earlier comic books, Tony Stark is a human. Outside the suit, he does not have any superpowers, however he has an enormous QI, in fact his intelligence gives to him the sufficient power instead of physycal superpowers. He made the suit himself, and nobody else can usually control it. Iron Man can fly and shoot beams from his hands using special technology called \"repulsors\" in his boots and gloves. He is not hurt by most weapons like guns and cannons. There are many versions of the Iron Man suit, because Stark keeps making improvements.In the later comic books, Stark took an experimental virus called \"STD\" which allowed him to control his suit with his mind and summon it wherever he was. Stark would eventually develop an armor that he could store in his body. This armor was known as the \"Bleeding Edge Model 37\".",
      "time":"1457018867393"
   },
   {
      "itemId":"10054",
      "name":"Deadpool",
      "image":"http://s8.hostingkartinok.com/uploads/images/2016/03/3d23f908f56428ac97840acae92c1f50.jpg",
      "description":"Deadpool (Wade Winston Wilson) is a fictional character appearing in American comic books published by Marvel Comics. Created by writer Fabian Nicieza and artist/writer Rob Liefeld, the character first appeared in The New Mutants #98 (cover-dated February 1991). Initially Deadpool was depicted as a supervillain when he made his first appearance in The New Mutants and later in issues of X-Force, but later evolved into his more recognizable antiheroic persona. Deadpool, whose real name is Wade Wilson, is a disfigured mercenary with the superhuman ability of an accelerated healing factor and physical prowess. The character is known as the \"Merc with a Mouth\" because of his tendency to talk and joke constantly, including breaking the fourth wall for humorous effect and running gags.The character's popularity has seen him featured in numerous forms of other media. In the 2004 series Cable & Deadpool, he refers to his own scarred appearance as \"Ryan Reynolds crossed with a Shar-Pei\" (though in the comic, Reynolds' name is misspelled as \"Renolds\".)Reynolds himself would eventually portray the character in the X-Men film series, appearing in X-Men Origins: Wolverine (2009), Deadpool (2016), and its sequel Deadpool 2 (2018). He is slated to continue playing the character in the Marvel Cinematic Universe.",
      "time":"1457018837658"
   },
   {
      "itemId":"10028",
      "name":"Thor",
      "image":"http://s8.hostingkartinok.com/uploads/images/2016/03/44819c5cf496a059797d43ffcab07508.jpg",
      "description":"Thor Odinson is the Asgardian God of Thunder, superhero, self-proclaimed protector of Earth and the king of Asgard. Thor made a name for himself as the mightiest warrior on his homeworld and subsequently became well known for his actions on Earth, which included acting as a founding member of the Avengers. He is the son of Odin Borson and Frigga, and the adopted brother of Loki Laufeyson. Thor wielded the mystical war hammer Mjölnir, which channeled his God of Thunder abilities until it was destroyed by his sister Hela. In an attempt to flee his sister, Thor found himself stranded on Sakaar where he was forced to be a champion in the Grandmaster's games. After escaping Sakaar, he brought about Ragnarök with the help of the Revengers and destroyed his home and Hela with it. He lead the Asgardian refugees away from the destruction in hunt for a new home.",
      "time":"1457018877305"
   },
   {
      "itemId":"10048",
      "name":"Hulk",
      "image":"http://s8.hostingkartinok.com/uploads/images/2016/03/dd54db9d3ea626ece12f4123d3b63306.jpg",
      "description":"The Hulk is a fictional superhero appearing in publications by the American publisher Marvel Comics. Created by writer Stan Lee and artist Jack Kirby, the character first appeared in the debut issue of The Incredible Hulk (May 1962). In his comic book appearances, the character is both the Hulk, a green-skinned, hulking and muscular humanoid possessing a vast degree of physical strength, and his alter ego Dr. Robert Bruce Banner, a physically weak, socially withdrawn, and emotionally reserved physicist, the two existing as independent personalities and resenting of the other. Following his accidental exposure to gamma rays saving the life of Rick Jones during the detonation of an experimental bomb, Banner is physically transformed into the Hulk when subjected to emotional stress, at or against his will, often leading to destructive rampages and conflicts that complicate Banner's civilian life. The Hulk's level of strength is normally conveyed as proportionate to his level of anger. Commonly portrayed as a raging savage, the Hulk has been represented with other personalities based on Banner's fractured psyche, from a mindless, destructive force, to a brilliant warrior, or genius scientist in his own right. Despite both Hulk and Banner's desire for solitude, the character has a large supporting cast, including Banner's lover Betty Ross, his best friend Rick Jones, his cousin She-Hulk, therapist and ally Doc Samson, and his co-founders of the superhero team the Avengers, etc. However, his uncontrollable power has brought him into conflict with his fellow heroes and others. Despite this he tries his best to do what's right while battling villains such as Leader, Abomination, Absorbing Man and more.",
      "time":"1457018788101"
   },
   {
      "itemId":"10056",
      "name":"IronMan",
      "image":"http://s8.hostingkartinok.com/uploads/images/2016/03/b70762d52599ffc44dc7539bf57baa1c.jpg",
      "description":"Iron Man is a superhero who wears a suit of armor. His alter ego is Tony Stark. He was created by Stan Lee, Jack Kirby and Larry Lieber for Marvel Comics in Tales of Suspense #39 in the year 1963 and appears in their comic books. He is also one of the main protagonists in the Marvel Cinematic Universe. In the movies and the earlier comic books, Tony Stark is a human. Outside the suit, he does not have any superpowers, however he has an enormous QI, in fact his intelligence gives to him the sufficient power instead of physycal superpowers. He made the suit himself, and nobody else can usually control it. Iron Man can fly and shoot beams from his hands using special technology called \"repulsors\" in his boots and gloves. He is not hurt by most weapons like guns and cannons. There are many versions of the Iron Man suit, because Stark keeps making improvements.In the later comic books, Stark took an experimental virus called \"STD\" which allowed him to control his suit with his mind and summon it wherever he was. Stark would eventually develop an armor that he could store in his body. This armor was known as the \"Bleeding Edge Model 37\".",
      "time":"1457018867393"
   },
   {
      "itemId":"10054",
      "name":"Deadpool",
      "image":"http://s8.hostingkartinok.com/uploads/images/2016/03/3d23f908f56428ac97840acae92c1f50.jpg",
      "description":"Deadpool (Wade Winston Wilson) is a fictional character appearing in American comic books published by Marvel Comics. Created by writer Fabian Nicieza and artist/writer Rob Liefeld, the character first appeared in The New Mutants #98 (cover-dated February 1991). Initially Deadpool was depicted as a supervillain when he made his first appearance in The New Mutants and later in issues of X-Force, but later evolved into his more recognizable antiheroic persona. Deadpool, whose real name is Wade Wilson, is a disfigured mercenary with the superhuman ability of an accelerated healing factor and physical prowess. The character is known as the \"Merc with a Mouth\" because of his tendency to talk and joke constantly, including breaking the fourth wall for humorous effect and running gags.The character's popularity has seen him featured in numerous forms of other media. In the 2004 series Cable & Deadpool, he refers to his own scarred appearance as \"Ryan Reynolds crossed with a Shar-Pei\" (though in the comic, Reynolds' name is misspelled as \"Renolds\".)Reynolds himself would eventually portray the character in the X-Men film series, appearing in X-Men Origins: Wolverine (2009), Deadpool (2016), and its sequel Deadpool 2 (2018). He is slated to continue playing the character in the Marvel Cinematic Universe.",
      "time":"1457018837658"
   },
   {
      "itemId":"10028",
      "name":"Thor",
      "image":"http://s8.hostingkartinok.com/uploads/images/2016/03/44819c5cf496a059797d43ffcab07508.jpg",
      "description":"Thor Odinson is the Asgardian God of Thunder, superhero, self-proclaimed protector of Earth and the king of Asgard. Thor made a name for himself as the mightiest warrior on his homeworld and subsequently became well known for his actions on Earth, which included acting as a founding member of the Avengers. He is the son of Odin Borson and Frigga, and the adopted brother of Loki Laufeyson. Thor wielded the mystical war hammer Mjölnir, which channeled his God of Thunder abilities until it was destroyed by his sister Hela. In an attempt to flee his sister, Thor found himself stranded on Sakaar where he was forced to be a champion in the Grandmaster's games. After escaping Sakaar, he brought about Ragnarök with the help of the Revengers and destroyed his home and Hela with it. He lead the Asgardian refugees away from the destruction in hunt for a new home.",
      "time":"1457018877305"
   },
   {
      "itemId":"10048",
      "name":"Hulk",
      "image":"http://s8.hostingkartinok.com/uploads/images/2016/03/dd54db9d3ea626ece12f4123d3b63306.jpg",
      "description":"The Hulk is a fictional superhero appearing in publications by the American publisher Marvel Comics. Created by writer Stan Lee and artist Jack Kirby, the character first appeared in the debut issue of The Incredible Hulk (May 1962). In his comic book appearances, the character is both the Hulk, a green-skinned, hulking and muscular humanoid possessing a vast degree of physical strength, and his alter ego Dr. Robert Bruce Banner, a physically weak, socially withdrawn, and emotionally reserved physicist, the two existing as independent personalities and resenting of the other.Following his accidental exposure to gamma rays saving the life of Rick Jones during the detonation of an experimental bomb, Banner is physically transformed into the Hulk when subjected to emotional stress, at or against his will, often leading to destructive rampages and conflicts that complicate Banner's civilian life. The Hulk's level of strength is normally conveyed as proportionate to his level of anger. Commonly portrayed as a raging savage, the Hulk has been represented with other personalities based on Banner's fractured psyche, from a mindless, destructive force, to a brilliant warrior, or genius scientist in his own right. Despite both Hulk and Banner's desire for solitude, the character has a large supporting cast, including Banner's lover Betty Ross, his best friend Rick Jones, his cousin She-Hulk, therapist and ally Doc Samson, and his co-founders of the superhero team the Avengers, etc. However, his uncontrollable power has brought him into conflict with his fellow heroes and others. Despite this he tries his best to do what's right while battling villains such as Leader, Abomination, Absorbing Man and more.",
      "time":"1457018788101"
   }
  ];

  bool _isDark = false;
  NetworkServices network = NetworkServices();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    Intl.defaultLocale = "ru";
    _isDark = context.read<ThemeNotifier>().isDarkMode;

    network.getItemList().then((value) => {
      print(value)
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_)=>ThemeNotifier(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("List"),
          actions: [
            Switch(
              value: _isDark,
              onChanged: (value){
                setState(() {
                  _isDark ? context.read<ThemeNotifier>().setLightMode() : context.read<ThemeNotifier>().setDarkMode();
                  _isDark = value;
                });
              },
            ),
          ], 
        ),
        body: SafeArea(
          bottom: false,
          child: ListView.separated(
            padding: EdgeInsets.only(top: 20),
            itemCount: items.length,
            itemBuilder: (context, i) => _item(i),
            separatorBuilder: (context, i) => SizedBox(height:20),
          ),
        ),
      ),
    );
  }

  _item(i){
    return Dismissible(
      key: Key(items[i]['itemId'].toString()),
      onDismissed: (direction){

      },
      child: Align(
        alignment: Alignment.center,
        child: Container(
          width: MediaQuery.of(context).size.width*0.9,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 2,
                offset: Offset.zero,
              ),
            ],
          ),
          child: Material(
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              onTap: (){

              },
              child: _itemBody(items[i]),
            ),
          ),
        ),
      )
    );
  }

  _itemBody(item){
    final dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(item['time']));
    final format = DateFormat('dd - MMMM - y HH:mm');
    final date = format.format(dateTime.toLocal());

    return Padding(
      padding: const EdgeInsets.all(9.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image(
              image: NetworkImage("${item['image']}"),
              width: 120,
              height: 85,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 15),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                
                Text(
                  "${item['name']}",
                  maxLines: 1,
                  style: Theme.of(context).primaryTextTheme.bodyText1,
                ),

                SizedBox(height: 8),
                Text(
                  "${item['description']}",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey
                  ),
                ),

                SizedBox(height: 8),
                Text(
                  "$date",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

}
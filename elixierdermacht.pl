:- include('buchderhilfe.pl').

% Dynamische Prädikate
:- dynamic(ist_an/2).
:- dynamic(has/1).
:- dynamic(gelernt/1).
:- dynamic(leben_spieler/1).
:- dynamic(leben_tyrael/1).
:- dynamic(im_kampf/1).
:- dynamic(leben_monster/3).
:- dynamic(gold/1).
gold(0).

% Orte
ort(dorf).
ort(wald).
ort(schmiede).
ort(bibliothek).
ort(marktplatz).
ort(dunkle_festung).
ort(friedhof).

% Verbindungen
weg(dorf, wald).
weg(wald, dorf).
weg(wald, schmiede).
weg(schmiede, wald).
weg(dorf, bibliothek).
weg(bibliothek, dorf).
weg(bibliothek, marktplatz).
weg(marktplatz, bibliothek).
weg(marktplatz, dunkle_festung).
weg(dunkle_festung, marktplatz).
weg(wald, friedhof).
weg(friedhof, wald).

% Charaktere und Standorte
ist_an(waldkraeuter_wilma, wald).
ist_an(eisenfaust_ewald, schmiede).
ist_an(schwertmeister_siegfried, marktplatz).
ist_an(magier_metron, bibliothek).
ist_an(dr_darius, bibliothek).
ist_an(fleischhauer_fernando, marktplatz).
ist_an(goblin_gerald, wald).
ist_an(tyrael, dunkle_festung).
ist_an(spieler, dorf).
ist_an(zombie, friedhof).
ist_an(skelett, friedhof).
ist_an(haendler_harald, marktplatz).

% Start
start :-
    write('Willkommen beim Text Adventure "Elixier der Macht"!'), nl,
    hilfe,
    beschreibe_ort(dorf), 
    write('Fremder: Suche im Wald nach Waldkraeuter Wilma.'), nl.

% Hilfe
hilfe :-
    write('Verfügbare Befehle:'), nl,
    write('- gehe(Ort).'), nl,
    write('- spreche_mit(Name).'), nl.

% Bewegung
gehe(Nach) :-
    ist_an(spieler, Ort),
    weg(Ort, Nach),
    retractall(ist_an(spieler, Ort)),
    assertz(ist_an(spieler, Nach)),
    beschreibe_ort(Nach), 
    random(1, 101, Zufall),
    (   
        Nach = wald,
        Zufall =< 10
        ->  
        remove_gold(50),
        write('Goblin Gerald hat dir Gold gestohlen.'), nl
        ;   
        true
    ),!.

gehe(_) :-
    write('Dort kannst du nicht hingehen.'), nl.
	
wege(X) :- ist_an(spieler, Ort), weg(Ort, X).

% Ortsbeschreibung
beschreibe_ort(Ort) :-
    write('Du bist nun in '), 
    write(Ort), 
    write('.'), nl,
    zeige_charaktere(Ort).

zeige_charaktere(Ort) :-
    findall(X, (ist_an(X, Ort), X \= spieler), Charaktere),
    schreibe_charaktere(Charaktere).

schreibe_charaktere([]).
schreibe_charaktere([Char|Rest]) :-
    write('Hier ist: '), 
    schreibe_name(Char), nl,
    schreibe_charaktere(Rest).

% Namen ausgeben
schreibe_name(waldkraeuter_wilma) :- write('Waldkräuter Wilma').
schreibe_name(eisenfaust_ewald) :- write('Eisenfaust Ewald').
schreibe_name(schwertmeister_siegfried) :- write('Schwertmeister Siegfried').
schreibe_name(magier_metron) :- write('Magier Metron').
schreibe_name(dr_darius) :- write('Dr. Darius').
schreibe_name(fleischhauer_fernando) :- write('Fleischhauer Fernando').
schreibe_name(goblin_gerald) :- write('Goblin Gerald').
schreibe_name(tyrael) :- write('Teuflischer Tyrann Tyrael').
schreibe_name(zombie) :- write('Zombie').
schreibe_name(skelett) :- write('Skelett').
schreibe_name(haendler_harald) :- write('Haendler Harald').
schreibe_name(schleimmonster) :- write('Schleimmonster').


% Interaktion
spreche_mit(wilma) :- spreche_mit(waldkraeuter_wilma), !.
spreche_mit(ewald) :- spreche_mit(eisenfaust_ewald), !.
spreche_mit(siegfried) :- spreche_mit(schwertmeister_siegfried), !.
spreche_mit(metron) :- spreche_mit(magier_metron), !.
spreche_mit(darius) :- spreche_mit(dr_darius), !.
spreche_mit(fernando) :- spreche_mit(fleischhauer_fernando), !.
spreche_mit(gerald) :- spreche_mit(goblin_gerald), !.
spreche_mit(harald) :- spreche_mit(haendler_harald), !.

spreche_mit(Name) :-
    ist_an(Name, Ort),
    ist_an(spieler, Ort),
    interaktion(Name), !.

spreche_mit(_) :-
    write('Diese Person ist nicht hier.'), nl.

% Dialoge
interaktion(waldkraeuter_wilma) :-
    write('Wilma: Suchst du Kräuter oder Wissen? Ich kann dir helfen!'), nl,
    (   has(buch) 
    ->  write('Ich kann dir nicht mehr weiterhelfen.'), nl
    ;   write('Hier ist ein maechtiges Buch.'), nl,
        add_item(buch),
        write('Oeffne es mit "buch."')
    ).

interaktion(eisenfaust_ewald) :-
    write('Ewald: Ich kann dir ein Schwert schmieden, wenn du mir das richtige Material bringst.'), nl,
    write('Ich kann dir folgende Dinge Schmieden:'), nl,
    write('1. Eisenschwert - 800 Gold'), nl,
    write('2. Eisenharnisch - 1200 Gold'), nl,
    write('Möchtest du etwas kaufen? (eisenschwert/eisenharnisch)'), nl,
    read(Option),
    handle_kauf(Option).

interaktion(schwertmeister_siegfried) :-
    write('Soll ich dir die Schwertkunst beibringen?'), nl,
    read(Option),
    (
        Option = 'J'
        ->  lehre_faehigkeit(schwertmeister_siegfried)
        ;   write('Vielleicht ein andermal.')
    ).

interaktion(magier_metron) :-
    write('Metron: Wassermagie ist mächtig, doch gefährlich. Willst du lernen?'), nl,
    write('Möchtest du (1) Feuermagie oder (2) Wassermagie lernen?'), nl,
    read(Option),
    lehre_faehigkeit(magier_metron, Option).

interaktion(dr_darius) :-
    write('Dr. Darius: Alchemie ist Unsinn! Aber vielleicht kann ich dir gegen Bezahlung ein Rezept überlassen.'), nl,
    write('Wenn du ein geheimes Rezept haben willst musst du mir bei einem Kampf helfen.'), nl,
    write('Hilfst du mir? (J/N)'), nl,
    read(Option),
    (
        Option = 'J'
        ->  kaempfe(schleimmonster)
        ;   write('Vielleicht ein andermal.')
    ).

interaktion(fleischhauer_fernando) :-
    write('Fernando: Frisches Fleisch, seltene Zutaten – alles was dein Herz begehrt.'), nl,
    (
        has(zombieherz)
        ->  write('Soll ich dir aus deinem Zombieherz einen Lebenstrank herstellen? J/N'), nl,
            lese_option(fleischhauer_fernando, zombieherz)
        ;   write('Ich kann dir gerade nicht helfen.')
    ).

interaktion(goblin_gerald) :-
    write('Gerald: Hihi… vielleicht habe ich etwas Nützliches für dich gestohlen…'), nl,
    write('Möchtest du (1) einen gestohlenen Ring erhalten oder (2) Diebstahl lernen?'), nl,
    lese_option(goblin_gerald).

interaktion(haendler_harald) :-
    write('Harald: Willkommen bei meinem Handel!'), nl,
    write('Ich kaufe folgende Items:'), nl,
    write('1. Zombieherz - 50 Gold'), nl,
    write('2. Lebenstrank - 30 Gold'), nl,
    write('3. Skelettkopf - 300 Gold'), nl,
    write('4. Knochen - 70'), nl,
    write('Was möchtest du verkaufen? (zombieherz/lebenstrank/skelettkopf/knochen/nichts)'), nl,
    read(Item),
    ( Item == nichts -> write('Vielleicht ein andermal.'), nl
    ; handle_handel(Item)
    ).
	
interaktion(tyrael) :-
    write('Tyrael: Du wagst es, mir gegenüberzutreten? Bereite dich vor!'), nl,
    kaempfe(tyrael).

handle_kauf(Item) :- 
    gold(Betrag),
    item_wert(Item, Wert),
    (
        Betrag >= Wert
        ->  remove_gold(Wert),
            add_item(Item)
        ;   write('Nicht genug Gold!')
    ).

handle_handel(Item) :-
    retract(has(Item)),
    item_wert(Item, Wert), % separate Faktendatenbank mit Preisen
    add_gold(Wert),
    format('Du hast ein ~w fuer ~w Gold verkauft!~n', [Item, Wert]), !.
	
handle_handel(_) :-
    write('Du hast diesen Gegenstand nicht zum Verkaufen.'), nl.

item_wert(zombieherz, 50).
item_wert(lebenstrank, 30).
item_wert(skelettkopf, 300).
item_wert(knochen, 70).
item_wert(eisenschwert, 800).
item_wert(eisenharnisch, 1200).

% Gold hinzufügen
add_gold(Betrag) :-
    gold(Alt),
    NeuerGold is Alt + Betrag,
    retract(gold(Alt)),
    assertz(gold(NeuerGold)).

remove_gold(Betrag) :-
    gold(Alt),
    NeuerGold is Alt - Betrag,
    retract(gold(Alt)),
    assertz(gold(NeuerGold)).

% Gold anzeigen
zeige_gold :-
    gold(Gold),
    format('Du hast ~w Gold.~n', [Gold]).

% Option einlesen
lese_option(Charakter, Delete) :-
    read(Option),
    handle_option(Charakter, Option, Delete).

lese_option(Charakter, _) :-
    read(Option),
    handle_option(Charakter, Option).

handle_option(Charakter, 'J', Delete) :- 
    gebe_item(Charakter),
    retract(has(Delete)).
handle_option(Charakter, 'J', _) :- gebe_item(Charakter).
handle_option(_, 'N', _) :- write('Vielleicht ein Andermal.'), nl.
handle_option(_, _, _) :- write('Ungültige Auswahl. Bitte gib J oder N ein.'), nl.

% Items erhalten
gebe_item(waldkraeuter_wilma) :- add_item(rezept_kraeutertrank).
gebe_item(eisenfaust_ewald) :- add_item(schmiedehammer).
gebe_item(schwertmeister_siegfried) :- add_item(trainingsschwert).
gebe_item(magier_metron) :- add_item(zauberstein).
gebe_item(dr_darius) :- add_item(geheimes_rezept).
gebe_item(fleischhauer_fernando) :- add_item(lebenstrank).
gebe_item(goblin_gerald) :- add_item(gestohlener_ring).

% Fähigkeiten lernen
lehre_faehigkeit(waldkraeuter_wilma) :- lerne(tipp_trankherstellung).
lehre_faehigkeit(eisenfaust_ewald) :- lerne(schmiedekunst).
lehre_faehigkeit(schwertmeister_siegfried) :- lerne(doppelschlag).
lehre_faehigkeit(magier_metron, 1) :- \+ gelernt(wassermagie), lerne(feuermagie).
lehre_faehigkeit(magier_metron, 2) :- \+ gelernt(feuermagie), lerne(wassermagie).

% Fähigkeit lernen
lerne(Faehigkeit) :-
    gelernt(Faehigkeit),
    write('Du beherrschst diese Fähigkeit bereits.'), nl, !.

lerne(Faehigkeit) :-
    assertz(gelernt(Faehigkeit)),
    write('Du hast gelernt: '), 
    write(Faehigkeit), nl.

% Item erhalten

add_item(Item) :-
    assertz(has(Item)),
    write('Du hast erhalten: '), 
    write(Item), nl.

% Inventar anzeigen
inventar :-
    findall(X, has(X), Items),
    (   Items = [] 
    ->  write('Du hast nichts dabei.'), nl
    ;   write('Dein Inventar: '), 
        write(Items), nl
    ),
    zeige_gold.

% Fähigkeiten anzeigen
faehigkeiten :-
    findall(X, gelernt(X), Skills),
    (   Skills = [] 
    ->  write('Du hast noch keine Fähigkeiten.'), nl
    ;   write('Gelernte Fähigkeiten: '), 
        write(Skills), nl
    ).

% Rezeptdefinitionen
rezept_fuer(elixier_der_macht, [geheimes_rezept, skelettkopf, zombieherz]).

% cheat
cheat_gold(Betrag) :-
    add_gold(Betrag).

cheat_skill(Skill) :- 
	lerne(Skill).

cheat_item(Item) :-
    add_item(Item).

% Tränke brauen
braue(Trank) :-
    rezept_fuer(Trank, Zutaten),
    (   has_alle(Zutaten) ->
        (   has(Trank) ->
            format('Du besitzt bereits: ~w', [Trank]), nl
        ;   
            verbrauche_zutaten(Zutaten),
            assertz(has(Trank)),
            format('Du hast erfolgreich den Trank gebraut: ~w', [Trank]), nl,
            trank_spezialtext(Trank)
        )
    ;   format('Dir fehlen Zutaten für: ~w', [Trank]), nl
    ), !.

braue(Trank) :-
    has(Trank),
    write('Du hast diesen Trank bereits gebraut.'), nl, !.

braue(_) :-
    write('Dir fehlen Zutaten oder das Wissen für diesen Trank.'), nl.
	
verbrauche_zutaten([]).
verbrauche_zutaten([Zutat|Rest]) :-
    retract(has(Zutat)),
    verbrauche_zutaten(Rest).

trank_spezialtext(elixier_der_macht) :-
    write('Mit diesem Elixier kannst du Tyrael gegenübertreten und die Welt retten!'), nl.
	
trank_spezialtext(_).

% Zutatencheck
has_alle([]).
has_alle([Zutat|Rest]) :-
    has(Zutat),
    has_alle(Rest).

% Fähigkeiten anwenden
anwenden(Faehigkeit) :-
    gelernt(Faehigkeit), !,
    write('Du setzt die Fähigkeit ein: '), write(Faehigkeit), nl,
    reaktion(Faehigkeit).

anwenden(_) :-
    write('Du beherrschst diese Fähigkeit nicht.'), nl.

% Spezialreaktionen
reaktion(doppelschlag) :-
    im_kampf(tyrael),
    leben_tyrael(LT),
    Schaden is 10,
    LTneu is LT - Schaden,
    retract(leben_tyrael(LT)),
    assertz(leben_tyrael(LTneu)),
    write('Du führst einen mächtigen Doppelschlag aus! 10 Schaden an tyrael!'), nl,
    check_kampfende,
    gegner_angriff.

reaktion(doppelschlag) :-
    im_kampf(Gegner),
    leben_monster(Gegner, LM),
    Schaden is 15,
    LMneu is LM - Schaden,
    retract(leben_monster(LM)),
    assertz(leben_monster(LMneu)),
    format('Du führst einen Doppelschlag aus. 15 Schaden an ~w', [Gegner]), nl,
    check_kampfende(Gegner),
    gegner_angriff(Gegner).

reaktion(wassermagie) :-
    im_kampf(tyrael),
    leben_tyrael(LT),
    Schaden is 20,
    LTneu is LT - Schaden,
    retract(leben_tyrael(LT)),
    assertz(leben_tyrael(LTneu)),
    write('Du setzt Wassermagie ein! 25 Schaden an Tyrael!'), nl,
    check_kampfende,
    gegner_angriff.

reaktion(wassermagie) :-
    im_kampf(Gegner),
    leben_monster(Gegner, LM),
    Schaden is 25,
    LMneu is LM - Schaden,
    retract(leben_monster(LM)),
    assertz(leben_monster(LMneu)),
    format('Du setzt Wassermagie ein. 25 Schaden an ~w', [Gegner]), nl,
    check_kampfende(Gegner),
    gegner_angriff(Gegner).



reaktion(feuermagie) :-
    im_kampf(tyrael),
    write('Du setzt Feuermagie ein, aber Tyrael ist immun!'), nl,
    gegner_angriff.    
	
reaktion(feuermagie) :-
    im_kampf(Gegner),
    leben_monster(Gegner, LM),
    Schaden is 25,
    LMneu is LM - Schaden,
    retract(leben_monster(Gegner, LM)),
    assertz(leben_monster(Gegner, LMneu)),
    format('Du setzt Feuermagie ein. 25 Schaden an ~w', [Gegner]), nl,
    check_kampfende(Gegner),
    gegner_angriff(Gegner).

kaempfe(tyrael) :-
    ist_an(spieler, dunkle_festung),
    (
        has(elixier_der_macht), \+ im_kampf(_), has(eisenharnisch), has(eisenschwert)
        ->  retractall(leben_spieler(_)),
            retractall(leben_tyrael(_)),
            assertz(leben_spieler(30)),
            assertz(leben_tyrael(70)),
            assertz(im_kampf(tyrael)),
            write('Der Kampf gegen Tyrael beginnt!'), nl,
            write('Benutze "angriff." oder "anwenden(Faehigkeit)."'), nl
        ;   write('Du bist noch nicht bereit!')
    ), !.

kaempfe(tyrael) :-
    im_kampf(_),
    write('Du befindest dich bereits im Kampf!'), nl, !.

kaempfe(zombie) :-
    ist_an(spieler, friedhof),
    \+ im_kampf(_),
    retractall(leben_spieler(_)),
    retractall(leben_monster(_,_)),
    assertz(leben_spieler(30)),
    assertz(leben_monster(zombie, 25)),
    assertz(im_kampf(zombie)),
    write('Der Kampf gegen Zombie beginnt!'), nl,
    write('Benutze "angriff." oder "anwenden(Faehigkeit)."'), nl, !.

kaempfe(skelett) :-
    ist_an(spieler, friedhof),
    \+ im_kampf(_),
    retractall(leben_spieler(_)),
    retractall(leben_monster(_,_)),
    assertz(leben_spieler(30)),
    assertz(leben_monster(skelett, 40)),
    assertz(im_kampf(skelett)),
    write('Der Kampf gegen Skelett beginnt!'), nl,
    write('Benutze "angriff." oder "anwenden(Faehigkeit)."'), nl, !.

kaempfe(schleimmonster) :-
    ist_an(spieler, bibliothek),
    \+ im_kampf(_),
    retractall(leben_spieler(_)),
    retractall(leben_monster(_,_)),
    assertz(leben_spieler(30)),
    assertz(leben_monster(schleimmonster, 25)),
    assertz(im_kampf(schleimmonster)),
    write('Der Kampf gegen ein Schleimmonster beginnt!'), nl,
    write('Benutze "angriff." oder "anwenden(Faehigkeit)."'), nl, !.

kaempfe(_) :-
    write('Hier gibt es niemanden, gegen den du kämpfen kannst.'), nl, !.

angriff :-
    im_kampf(tyrael), !,
    leben_tyrael(LT),
    Grundschaden is 5,
	(
		has(eisenschwert)
		-> Schaden is truncate(Grundschaden*1.3)	
		; Schaden is Grundschaden
	),
    LTneu is LT - Schaden,
    retract(leben_tyrael(LT)),
    assertz(leben_tyrael(LTneu)),
    format('Du greifst Tyrael an und verursachst ~w Schaden!', [Schaden]), nl,
    check_kampfende,
    gegner_angriff.

angriff :-
    im_kampf(Gegner), !,
    leben_monster(Gegner, LM),
    Grundschaden is 6,
	(
		has(eisenschwert)
		-> Schaden is truncate(Grundschaden*1.3)
		; Schaden is Grundschaden
	),
    LMneu is LM - Schaden,
    retract(leben_monster(Gegner, LM)),
    assertz(leben_monster(Gegner, LMneu)),
    write('Du greifst '), schreibe_name(Gegner), format(' an und verursachst ~w Schaden!', [Schaden]), nl,
    check_kampfende(Gegner),
    gegner_angriff(Gegner).


angriff :-
    write('Du bist gerade nicht im Kampf.'), nl.

gegner_angriff :-
    leben_spieler(LS),
	random(6,10,R),
	format('~w', [R]),
    Grundschaden is R,
	(
		has(eisenharnisch)
		-> Schaden is truncate(Grundschaden*0.7)
		; Schaden is Grundschaden
	),
    LSneu is LS - Schaden,
    retract(leben_spieler(LS)),
    assertz(leben_spieler(LSneu)),
    write('Tyrael greift dich an und verursacht 6 Schaden!'), nl,
    check_kampfende.

gegner_angriff(Gegner) :-
    leben_spieler(LS),
	random(5,8,Z),
	random(9,12,S),
	random(14,17,T),
    (
        Gegner = zombie
        ->  Grundschaden is Z
        ; (
            Gegner = skelett
            ->  Grundschaden is S
            ; Grundschaden is T
        )
    ),
	(
		has(eisenharnisch)
		-> Schaden is truncate(Grundschaden*0.7)
		; Schaden is Grundschaden
	),
    LSneu is LS - Schaden,
    retract(leben_spieler(LS)),
    assertz(leben_spieler(LSneu)),
    write(''), schreibe_name(Gegner), 
    format(' greift dich an und verursacht ~w Schaden!', [Schaden]), nl,
    check_kampfende(Gegner).

check_kampfende :-
    leben_tyrael(LT),
    LT =< 0,
    write('Du hast Tyrael besiegt! Die Welt ist gerettet!'), nl,
    retractall(im_kampf(_)),
    retractall(leben_spieler(_)),
    retractall(leben_tyrael(_)), !.

check_kampfende :-
    leben_spieler(LS),
    LS =< 0,
    write('Du wurdest von Tyrael besiegt. Die Welt versinkt im Chaos...'), nl,
    game_over, !.


check_kampfende :-
    leben_spieler(LS),
    leben_tyrael(LT),
    write('Dein Leben: '), write(LS), write(' | Tyraels Leben: '), write(LT), nl.

check_kampfende(Gegner) :-
    leben_monster(Gegner, LM),
    LM =< 0,
    write('Du hast '), schreibe_name(Gegner), write(' besiegt!'), nl,
    mob_drop(Gegner),
    retractall(im_kampf(_)),
    retractall(leben_spieler(_)),
    retractall(leben_monster(_,_)), !.

check_kampfende(_) :-
    leben_spieler(LS),
    LS =< 0,
    write('Du wurdest im Kampf besiegt.'), nl,
    game_over, !.

check_kampfende(Gegner) :-
    leben_spieler(LS),
    leben_monster(Gegner, LM),
    write('Dein Leben: '), write(LS), write(' | Leben von '), schreibe_name(Gegner), write(': '), write(LM), nl.

% Trank trinken
trinke(lebenstrank) :-
    im_kampf(_),
    has(lebenstrank),
    leben_spieler(LS),
    Heilung is 10,
    LSneu is LS + Heilung,
    retract(leben_spieler(LS)),
    assertz(leben_spieler(LSneu)),
    retract(has(lebenstrank)),
    write('Du trinkst einen Lebenstrank und regenerierst 10 Leben!'), nl,
    check_kampfende,
    gegner_angriff, !.

trinke(lebenstrank) :-
    \+ has(lebenstrank),
    write('Du hast keinen Lebenstrank.'), nl, !.

trinke(_) :-
    write('Diesen Trank kannst du nicht trinken oder er existiert nicht.'), nl.

game_over :-
    nl, write('-------------------------Game over--------------------------'), nl, nl,
    retractall(im_kampf(_)),
    retractall(leben_spieler(_)),
    retractall(leben_tyrael(_)),
    retractall(has(_)),
    retractall(gelernt(_)),
    gold(Gold),
    remove_gold(Gold),
    write('Dein Inventar und deine Faehigkeiten wurden verloren.'), nl, !.

write_map :-
    nl,
    write('    +----------+'), nl,
    write('    | Friedhof |'), nl,
    write('    +----------+'), nl,
    write('         |'), nl,
    write('         |'), nl,
    write('    +--------+        +----------+'), nl,
    write('    |  Wald  |--------| Schmiede |'), nl,
    write('    +--------+        +----------+'), nl,
    write('         |'), nl,
    write('         |'), nl,
    write('    +------+    +------------+    +------------+    +---------------+'), nl,
    write('    | Dorf |----| Bibliothek |----| Marktplatz |----| Dunkle_Festung|'), nl,
    write('    +------+    +------------+    +------------+    +---------------+'), nl,
    nl.
    
mob_drop(zombie) :- add_item(zombieherz).
mob_drop(skelett) :-
    random(1, 101, Zufall),
    (
        Zufall =< 10
        ->  add_item(skelettkopf)
        ;   add_item(knochen)
    ).
mob_drop(schleimmonster) :- add_item(schleim), add_item(geheimes_rezept),
	write('Du bekommst einen Schleim und ein geheimes Rezept'), nl.
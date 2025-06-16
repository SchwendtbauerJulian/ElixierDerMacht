:- dynamic(aktuelle_seite/1).

% Startseite
aktuelle_seite(1).

% Hauptbefehl zum oeffnen des Buches
buch :-
    (
        \+ has(buch)
        ->  write('Du besitzt noch kein Buch.')
        ;  retractall(aktuelle_seite(_)),
            assertz(aktuelle_seite(1)),
            zeige_seite(1)
    ).

% Navigation
naechste_seite :-
    aktuelle_seite(N),
    N1 is N + 1,
    (seite_existiert(N1) ->
        (retract(aktuelle_seite(N)),
         assertz(aktuelle_seite(N1)),
         zeige_seite(N1))
    ;   write('Das ist bereits die letzte Seite.'), nl).

vorherige_seite :-
    aktuelle_seite(N),
    N1 is N - 1,
    (N1 > 0 ->
        (retract(aktuelle_seite(N)),
         assertz(aktuelle_seite(N1)),
         zeige_seite(N1))
    ;   write('Das ist bereits die erste Seite.'), nl).

gehe_zu_seite(Seite) :-
    (seite_existiert(Seite) ->
        (retractall(aktuelle_seite(_)),
         assertz(aktuelle_seite(Seite)),
         zeige_seite(Seite))
    ;   write('Diese Seite existiert nicht.'), nl).

% Pruefung ob Seite existiert
seite_existiert(N) :- N >= 1, N =< 7.

% Seiteninhalt
zeige_seite(N) :-
    nl,
    write('==============================================='), nl,
    write('        ELIXIER DER MACHT - HILFEBUCH'), nl,
    write('==============================================='), nl,
    seiten_inhalt(N),
    nl,
    write('Seite '), write(N), write(' von 7'), nl,
    write('-----------------------------------------------'), nl,
    write('Befehle: naechste_seite. | vorherige_seite.'), nl,
    write('         gehe_zu_seite(N). | buch_hilfe.'), nl,
    write('==============================================='), nl.


% Seite 1: Inhalt
seiten_inhalt(1) :-
    write('              WILLKOMMEN ABENTEURER!'), nl, nl,
    write('Dieses Buch fuehrt dich durch die Welt des'), nl,
    write('Elixiers der Macht. Dein Ziel: Sammle Zutaten,'), nl,
    write('lerne Faehigkeiten und besiege den boesen Tyrael!'), nl, nl,
    write('SEITENUEBERSICHT:'), nl,
    write('1. Inhalt'), nl,
    write('2. Willkommen & Grundbefehle'), nl,
    write('3. Die Welt & Orte'), nl,
    write('4. Wichtige Charaktere'), nl,
    write('5. Das Elixier der Macht'), nl,
    write('6. Kampfsystem'), nl,
    write('7. Tipps & Tricks'), nl.

% Seite 2: Willkommen
seiten_inhalt(2) :-
    write('GRUNDBEFEHLE:'), nl,
    write('- gehe(ort).          Bewege dich'), nl,
    write('- wege(X)             Moegliche Wege'), nl,
    write('- spreche_mit(name).  Rede mit Charakteren'), nl,
    write('- inventar.           Zeige Items'), nl,
    write('- faehigkeiten.       Zeige Faehigkeiten'), nl,
    write('- braue(trank).       Braue Traenke'), nl,
    write('- hilfe.              Zeige Spielhilfe'), nl.

% Seite 3: Die Welt
seiten_inhalt(3) :-
    write('                  DIE WELT'), nl, nl,
    write('    [Friedhof]'), nl,
    write('        |'), nl,
    write('    [Wald]-----[Schmiede]'), nl,
    write('        |'), nl,
    write('    [Dorf]--[Bibliothek]--[Marktplatz]--[Festung]'), nl, nl,
    write('ORTE:'), nl,
    write('- Dorf: Dein Startort'), nl,
    write('- Wald: Waldkraeuter Wilma, Goblin Gerald'), nl,
    write('- Schmiede: Eisenfaust Ewald'), nl,
    write('- Bibliothek: Magier Metron, Dr. Darius'), nl,
    write('- Marktplatz: Siegfried, Fernando'), nl,
    write('- Dunkle Festung: Tyrael (Endgegner)'), nl,
    write('- Friedhof: Zombie Zoe, Zombie Zack'), nl.

% Seite 4: Wichtige Charaktere
seiten_inhalt(4) :-
    write('              WICHTIGE CHARAKTERE'), nl, nl,
    write('WALDKRaeUTER WILMA (Wald):'), nl,
    write('- Item: Buch'), nl,
    write('MAGIER METRON (Bibliothek):'), nl,
    write('- Faehigkeit: Feuer/Wassermagie'), nl, nl,
    write('FLEISCHHAUER FERNANDO (Marktplatz):'), nl,
    write('- Item: Lebenstrank'), nl,
    write('SCHWERTMEISTER SIEGFRIED (Marktplatz):'), nl,
    write('- Faehigkeit: Doppelschlag'), nl.

% Seite 5: Das Elixier der Macht
seiten_inhalt(5) :-
    write('            DAS ELIXIER DER MACHT'), nl, nl,
    write('BENOETIGTE ZUTATEN:'), nl,
    write('1. geheimes Rezept'), nl,
    write('2. Skelettkopf'), nl,
    write('3. Zombieherz'), nl, nl,
    write('BRAUEN:'), nl,
    write('?- braue(elixier_der_macht).'), nl, nl,
    write('WICHTIG: Du brauchst das Elixier der Macht,'), nl,
    write('um gegen Tyrael kaempfen zu koennen!'), nl.

% Seite 6: Kampfsystem
seiten_inhalt(6) :-
    write('               KAMPFSYSTEM'), nl, nl,
    write('KAMPF STARTEN:'), nl,
    write('?- kaempfe(gegner).'), nl, nl,
    write('KAMPFBEFEHLE:'), nl,
    write('- angriff.              (5 Schaden vs Tyrael)'), nl,
    write('- anwenden(doppelschlag). (10 Schaden!)'), nl,
    write('- anwenden(messerwurf).   (7 Schaden)'), nl,
    write('- trinke(heiltrank).      (10 LP zurueck)'), nl, nl,
    write('LEBENSPUNKTE:'), nl,
    write('- Spieler: 30 LP'), nl,
    write('- Tyrael: 400 LP (6 Schaden/Runde)'), nl,
    write('- Zombies: 20-25 LP (4 Schaden/Runde)'), nl, nl,
    write('TIPP: Lerne Doppelschlag fuer Tyrael!'), nl.

% Seite 7: Tipps & Tricks
seiten_inhalt(7) :-
    write('               TIPPS & TRICKS'), nl, nl,
    write('NUETZLICHE BEFEHLE:'), nl,
    write('- write_map.     Zeige Weltkarte'), nl,
    write('- inventar.      Pruefe Items'), nl,
    write('- faehigkeiten.  Pruefe Faehigkeiten'), nl, nl,
    write('ZOMBIE TRAINING:'), nl,
    write('uebe im Friedhof gegen Zombies, bevor du'), nl,
    write('gegen Tyrael kaempfst!'), nl, nl,
    write('VIEL ERFOLG BEIM RETTEN DER WELT!'), nl.

% Hilfefunktion fuer das Buch
buch_hilfe :-
    nl,
    write('BUCH NAVIGATION:'), nl,
    write('- buch.              oeffne das Buch'), nl,
    write('- naechste_seite.    Naechste Seite'), nl,
    write('- vorherige_seite.   Vorherige Seite'), nl,
    write('- gehe_zu_seite(N).  Springe zu Seite N'), nl,
    write('- buch_hilfe.        Diese Hilfe'), nl, nl.

% Kurzbefehle
n :- naechste_seite.
v :- vorherige_seite.
s(N) :- gehe_zu_seite(N).


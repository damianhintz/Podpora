Podpora v1.0-beta, 28 czerwca 2017
---
Rysowanie odchyłek podpory

# Pomoc

1. Zainstaluj program w [katalogu mdlapps]($MSDIR/mdlapps)
2. Konfiguruj program w [pliku config](Podpora.config)
3. Uruchom program za pomocą wpisania keyin: `mdl load Podpora`
4. Wybierz ogrodzenie
5. Rysuj odchyłki za pomocą wpisania keyin:  
    Podpora load

# Historia

Do zrobienia:

- [ ] wybieranie pliku z punktami pierwotnymi
- [ ] skanowanie pliku w poszukiwaniu punktów pierwotnych
- [ ] asocjacja punktów pomierzonych i pierwotnych
 - [ ] uwielbiane punkty pierwotne (wiele pomierzonych punktów)
 - [ ] samotne punkty pierwotne
- [ ] eksport raportu asocjacji do pliku
- [ ] samotne punkty pomierzone
- [ ] wstawianie strzałki reprezentującej odchyłkę punktu pomierzonego
 - [ ] rysowanie strzałki prostopadle do boku podpory
 - [ ] wstawianie opisu punktu
 - [ ] wstawianie odchyłki

2016-06-28 v1.0-beta

* nowe polecenie do ustawiania domyślnego stylu: `Podpora arrow style 0`
* nowe polecenie do ustawiania domyślnej grubości: `Podpora arrow weight 1`
* nowe polecenie do ustawiania warstwy punktu początkowego (podpora ref startLevel)
* nowe polecenie do ustawiania warstwy punktu końcowego (podpora ref endLevel)
* nowe polecenie do odczytywania konfiguracji z pliku Podpora.config
* nowe polecenie do ustawiania warstwy strzałki (podpora arrow level)
* nowe polecenie do ustawiania czcionki numeru strzałki (podpora arrow font)
* wstawianie numeru strzałki pod odpowiednim kątem
* odwracanie numeru strzałki dla kątów od 90 do 270

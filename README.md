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

- [x] usuń myślnik z nazwy strzałki bez prefiksu

2016-06-28 v1.0-beta

* nowe polecenie do ustawiania domyślnego stylu: `PhotoArrow arrow style 0`
* nowe polecenie do ustawiania domyślnej grubości: `PhotoArrow arrow weight 1`
* wybór obszaru ogrodzenia przez użytkownika
* zmiana domyślnych warstw kierunku zdjęć na 7 i 47
* nowe polecenie do ustawiania warstwy punktu początkowego (photoarrow ref startLevel)
* nowe polecenie do ustawiania warstwy punktu końcowego (photoarrow ref endLevel)
* nowe polecenie do odczytywania konfiguracji z pliku PhotoArrow.config (automatycznie wykonywane podczas startu)
* nowe polecenie do ustawiania podkatalogu zdjęć (photoarrow photo subdir)
* nowe polecenie do ustawiania typu zdjęć (photoarrow photo ext)
* nowe polecenie do ustawiania warstwy strzałki (photoarrow arrow level)
* nowe polecenie do ustawiania czcionki numeru strzałki (photo arrow font)
* nowe polecenie do ustawiania koloru strzałki (photo arrow color)
* nowe polecenie do ustawiania rozmiaru numeru strzałki (photo arrow textSize)
* wykrywanie brakujących strzałek
* wykrywanie brakujących plików zdjęć
* wykrywanie duplikatów strzałek
* pierwsza wersja programu
* wyszukiwanie numerów zdjęć
* wstawianie strzałek
* wstawianie numeru strzałki pod odpowiednim kątem
* odwracanie numeru strzałki dla kątów od 90 do 270

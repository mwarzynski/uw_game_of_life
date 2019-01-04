Zadanie 3: automat komórkowy
W zadaniu 3 zajmiemy się ,,grą w życie'', ale tym razem będziemy pracować na ARMie (a ściślej na emulatorze obecnym w pracowni).

Naszym celem będzie napisanie funkcji realizujących symulację automatu komórkowego Conwaya, tzw. ,,gry w życie''. Gra odbywa się na prostokątnej planszy składającej się z kwadratowych komórek. Każda komórka może być żywa lub martwa.

Czas jest dyskretny, w każdym kroku symulacji:

Każda żywa komórka, która ma 4 lub więcej żywych sąsiadów ,,umiera'' z powodu tłoku.
Każda żywa komórka, która ma mniej niż 2 sąsiadów ,,umiera'' z osamotnienia.
Jeśli martwa komórka ma dokładnie 3 żywych sąsiadów, to ,,ożywa''.
Przez sąsiadów komórki rozumiemy 8 komórek bezpośrednio otaczających ją.

Część napisana w języku wewnętrznym powinna eksportować procedury wołane z C:

void start(int szer, int wys, char* T)

Przygotowuje symulację.

void run()

Przeprowadza jeden krok symulacji, po jego wykonaniu tablica T (przekazana przez start) zawiera nowy stan.

Dokładna postać wewnętrzna tablicy T nie jest określona, powinno być jednak możliwe jej łatwe zainicjowanie w programie w C przez wczytanie początkowej zawartości z pliku zawierającego kolejno:

liczbę kolumn (szerokość) i wierszy (wysokość) w pierwszym wierszu;
W kolejnych wierszach wiersze tablicy T w postaci zer (martwa komórka) i jedynek (żywa komórka), rozdzielonych pojedynczymi spacjami.
Testowy program główny napisany w C powinien zainicjować tablicę T i rozpocząć symulację. Po każdym wywołaniu procedury run powinno się wyświetlić aktualną sytuację -- może być tekstowo, czyli gwiazdki i spacje lub tp. Program powinien otrzymać jako argumenty nazwę pliku i liczbę kroków.

Rozwiązania nie zawierające pliku Makefile nie będą sprawdzane.

Rozwiązania (procedury w asemblerze i program w C wraz z przykładowymi testami) należy wysłać do końca zajęć (26 stycznia 2019, 23:59) pocztą na zbyszek@mimuw.edu.pl jako pojedynczy załącznik -- archiwum o nazwie wskazującej na autora (np. ab123456-zad3.tgz), spakowane z osobnego katalogu o tej samej nazwie (ale bez tgz). Program ma działać na emulatorze QEMU zainstalowanym w laboratoriach w ARMv4 lub AMv5.

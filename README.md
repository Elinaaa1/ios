# MeetUp — Stage 3 (wersja z komentarzami)

Projekt jest uporzadkowany wedlug **Feature-First**. Kod zachowuje funkcjonalnosc poprzedniego etapu, a sekcje oznaczono komentarzami `// MARK:` po polsku.

## Instalacja w Xcode
1. Zrob kopie obecnego projektu.
2. Wypakuj archiwum.
3. Zamien odpowiednie pliki .swift na zawartosc folderu MeetUp (bez duplikowania ich w target).
4. Dodaj pliki do target iOS, a nastepnie nacisnij Cmd+B i Cmd+R.
5. Minimalny iOS: 17.

## Scenariusz prezentacji
1. `App/ContentView.swift` — cztery zakladki.
2. `Features/Events/Views/EventEditorView.swift` — formularz i `saveEvent()`.
3. `Core/Storage/EventStore.swift` — `add`, `update`, `delete`, `save`.
4. `Features/Events/Views/EventDetailView.swift` — sekcje Polls i Shared expenses; `totalExpenses(for:)`.
5. `Features/Voting/PollEditorView.swift` — walidacja `canSave` i `createPoll()`.
6. `Features/Voting/MeetingPoll.swift` — `countVotes`, `maximumVoteCount`, `winningOptions`, `castVote`.
7. `Features/Voting/PollDetailView.swift` — pasek procentowy i `submitVote`.

### Uwaga
- `UserDefaults` sluzy do lokalnego przechowywania danych; to nie jest Firebase ani synchronizacja.
- Glosowanie odbywa sie na jednym urzadzeniu po wybraniu nazwy uczestnika.
- Kwota 'Per person' to rowny podzial wydatkow, nie rozliczenia dlugow.
- Nazwy typow `Meeting`, `MeetingPoll`, `EventStore` pozostaja bez zmian, aby nie uszkodzic powiazan.

class VoteBackend {
  static final Map<String, int> _votes = {
    'Mean Girls': 70,
    'Dune: Part Two': 45,
    'Inside Out 2': 50,
    'IF': 12,
    'Marmalade': 7,
    'Argyle': 9,
  };

  static void addVote(String title) {
    _votes[title] = (_votes[title] ?? 0) + 1;
  }

  static Map<String, int> getVotes() => _votes;
}

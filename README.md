mpl
===

Wrapper script around mpc for easier last.fm integration and usage of MPD's last.fm stream loading capabilites.
Your MPD daemon must configured to use last.fm.

Usage: mpl [option] [data] {optional_info} {number of tracks}

    + option (mandatory) is one of:
                                  u|user
                                  a|artist
                                  g|genre
                                  ut|usertags
                                  gt|globaltags

    + data (mandatory) depends on the above given option and is one of: lastfm_username, artist_name, genre, lastfm_globaltag, lastfm_usertag

    + optional_info (optional) is additional data given to further filter the above search and is one of:
                                  for lastfm_username: loved, personal, recommended, playlist
                                  for lastfm_usertags: tag
                                  for lastfm_globaltags: tag
                                  for artist_name: similarartist, fans

    + number_of_tracks (optional): the MPD last.fm plugin loads only 5 tracks by default for each call. If you want to load more tracks, supply
                                 a number as the last argument and it will multiply this by 5, thus loading 5 x n tracks. If you don't specify
                                 this number by default it will load 25 tracks.

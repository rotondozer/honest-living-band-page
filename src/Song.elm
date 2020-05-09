module Song exposing (Song(..), downloadLink, getTitle, previewLink)

-- Songs are stored in a personal google drive.
-- https://drive.google.com/open?id=1qKTDdmhHrC7_2p2l1IQta7d_YIJOyz3W Seasonal
-- https://drive.google.com/open?id=1L7YOr9L4gvARk6orSxbdkLflOWXfNKZF isswttd
-- https://drive.google.com/open?id=1xMRM-0heaytWptb66yFG0jyofXGI2AXD Hope and Olney
-- 1XHvfbaR5zQliqErhuTRua6UGfJoUinDt Closer


type Song
    = Seasonal
    | Isswttd
    | HopeAndOlney
    | NeverACloser


getId : Song -> String
getId song =
    case song of
        Seasonal ->
            "1qKTDdmhHrC7_2p2l1IQta7d_YIJOyz3W"

        Isswttd ->
            "1L7YOr9L4gvARk6orSxbdkLflOWXfNKZF"

        HopeAndOlney ->
            "1xMRM-0heaytWptb66yFG0jyofXGI2AXD"

        NeverACloser ->
            "1XHvfbaR5zQliqErhuTRua6UGfJoUinDt"


getTitle : Song -> String
getTitle song =
    case song of
        Seasonal ->
            "Seasonal"

        Isswttd ->
            "I Should Start Writing These Things Down"

        HopeAndOlney ->
            "Hope and Olney"

        NeverACloser ->
            "Never a Closer"


previewLink : Song -> String
previewLink song =
    "https://drive.google.com/file/d/" ++ getId song ++ "/preview"


downloadLink : Song -> String
downloadLink song =
    "https://drive.google.com/u/0/uc?id=" ++ getId song ++ "&export=download"

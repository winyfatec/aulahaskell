{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Jogo where

import Import
import Database.Persist.Postgresql
import Text.Lucius
import Text.Julius

getJogoR :: Int -> Handler Html
getJogoR jid = do
    defaultLayout $ do
        sess <- lookupSession "_NOME"
        setTitle "Aula Haskell Fatec :: Jogo"
        addStylesheet $ StaticR css_main_css
        addScript $ StaticR js_main_js
        addScript $ StaticR js_pacman_js
        toWidgetHead [hamlet|
            <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
            <script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
            <script>
                (adsbygoogle = window.adsbygoogle || []).push({ google_ad_client: "ca-pub-3156965201812393",enable_page_level_ads: true});
            <script src="https://code.jquery.com/jquery-3.4.1.min.js" integrity="sha256-CSXorXvZcTkaix6Yvo6HppcZGetbYMGWSFlBw8HfCJo=" crossorigin="anonymous">
            <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous">
            <script src="https://cdnjs.cloudflare.com/ajax/libs/modernizr/2.8.3/modernizr.min.js" integrity="sha256-0rguYS0qgS6L4qVzANq4kjxPLtvnp5nn2nB5G1lWRv4=" crossorigin="anonymous">
        |]
        
        let jogos = case jid of
                1 -> show $ StaticR atividadecorredor_swf
                2 -> show $ StaticR atividadeshooter_swf
                3 -> show $ StaticR jogolutav4_swf
                        
        $(whamletFile "templates/menu.hamlet")
        $(whamletFile "templates/jogo.hamlet")
        $(whamletFile "templates/footer.hamlet")

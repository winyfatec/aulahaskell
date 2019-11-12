{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Aula where

import Import
--import Network.HTTP.Types.Status
import Database.Persist.Postgresql
import Text.Lucius
import Text.Julius

getPage2R :: Handler Html
getPage2R = do
    defaultLayout $ do
        $(whamletFile "templates/page2.hamlet")

getPage1R :: Handler Html
getPage1R = do
    defaultLayout $ do
        $(whamletFile "templates/page1.hamlet")
        toWidgetHead $(luciusFile "templates/page1.lucius")
        toWidgetHead $(juliusFile "templates/page1.julius")

getAulaR :: Handler Html
getHomeAulaR = do
    defaultLayout $ do
    --addStylesheet (StaticR css_bootstrap_css)
    --addScript (StaticR js_main_js)
        setTitle "Aula Haskell Fatec"
        addStylesheetRemote "https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
        addScriptRemote "http://ajax.googleapis.com/ajax/libs/jquery/1.9.0/jquery.min.js"
        addScriptRemote "https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"
        --addScriptRemote "//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js" async
        addStylesheet $ StaticR css_main_css
        addScript $ StaticR js_main_js
        toWidgetHead [julius|
            function ola(){
                alert("OI");
            }
        |]
        toWidgetHead [cassius|
            h1
                color : blue;
        |]    
        toWidgetHead [hamlet|
            <script data-ad-client="ca-pub-4764459455736825" async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js">
            <script>
                (adsbygoogle = window.adsbygoogle || []).push({
                google_ad_client: "pub-4764459455736825",
                enable_page_level_ads: true
                });
        |]
        [whamlet|
        
            <div class="container">
            
            <ul class="menuhask">
                <li class="menuhaskitem">
                    <a href=@{Page1R}>
                        Pagina 1
                <li class="menuhaskitem">
                    <a href=@{Page2R}>
                        Pagina 2
                
        |]

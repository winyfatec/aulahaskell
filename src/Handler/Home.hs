{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Home where

import Import
--import Network.HTTP.Types.Status
import Database.Persist.Postgresql
import Text.Lucius
import Text.Julius
{-
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
-}
getHomeR :: Handler Html
getHomeR = do
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
                
            
            
                <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
                    <div class="collapse navbar-collapse">
                        <ul class="navbar-nav">
                            <li class="nav-item active">
                                <a class="nav-link" href="#">
                                    Home
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" id="navbarDropdownMenuLink" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                    Jogo
                                <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                                    <a class="dropdown-item" href="#">
                                        Descrição
                                    <a class="dropdown-item" href="#">
                                        Jogar
                                        
                <div id="carouselExampleControls" class="carousel slide" data-ride="carousel">
                    <div class="carousel-inner">
                        <div class="carousel-item active">
                            <img class="d-block w-100" src=@{StaticR slide1_jpg}>
                            <div class="carousel-caption d-none d-md-block">
                                <span class="legenda">
                                    Em breve...
                        <div class="carousel-item">
                            <img class="d-block w-100" src=@{StaticR slide2_jpg}>
                            <div class="carousel-caption d-none d-md-block">
                                <span class="legenda">
                                    Em breve...
                    <a class="carousel-control-prev" href="#carouselExampleControls" role="button" data-slide="prev">
                        <span class="carousel-control-prev-icon" aria-hidden="true">
                    <a class="carousel-control-next" href="#carouselExampleControls" role="button" data-slide="next">
                        <span class="carousel-control-next-icon" aria-hidden="true">
                    
                    
            <div class="foot">
                <img id="imgfatec" src=@{StaticR fatec_png}>
                <span class="copytext">
                    Desenvolvido para a disciplina de Tópicos Especiais em Informática na Fatec BS
        |]

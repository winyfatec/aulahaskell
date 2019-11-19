{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Ator where

import Import
--import Network.HTTP.Types.Status
import Database.Persist.Postgresql
import Text.Lucius
import Text.Julius


formAtor :: Form Ator
formAtor  = renderBootstrap $ Ator
    <$> areq textField "Nome" Nothing
    <*> areq dayField "Nascimento" Nothing



getAtorR :: Handler Html
getAtorR = do
    (widget,enctype) <- generateFormPost formAtor
    defaultLayout $ do
        msg <- getMessage
        [whamlet|
            $maybe mensa <- msg
                <div>
                    ^{mensa}
            $nothing
            
            <h1>
                Cadastro de Ator
            <form method=post action=@{AtorR}>
                ^{widget}
                <input type="submit" value="Cadastrar">
        |]


postAtorR :: Handler Html
postAtorR = do
    ((result,_),_) <- runFormPost formAtor
    case result of
        FormSuccess ator -> do
            runDB $ insert ator
            setMessage [shamlet|
                <h2>
                    Ator inserido com sucesso
            |]
            redirect AtorR
        _ -> redirect HomeR


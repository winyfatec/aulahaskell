import Database.Persist.Postgresql

getHomeR :: Handler Html
getHomeR = do
    defaultLayout $ do
    addStylesheet (css_bootstrap_css)
        toWidgetHead [julius|
            function ola(){
                alert("OI");
            }
        |]
        toWidgetHead [cassius|
            h1
                color : blue;
                width: 100px;
                background-color : yellow;
        |]    
        [whamlet|
            <h1>
                OI MUNDO!
            
            <img src=@{StaticR fatec_jpg}>

            <button onclick="ola()">
                OK!
        |] 
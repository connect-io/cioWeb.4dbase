// ----- Init de l'objet de récupération des datas 4D -----
if(data4D == null){
    var data4D = {};
}

data4D.debugConsole = function (message) {
    if (this.debugMode) {
        console.log(message);
    }
};

<!--#4DIF (charts_o#null)-->
    // Récupération de data 4D propre à cette page.
    data4D.chart_o = <!--#4DHTML JSON Stringify(charts_o)-->;

    <!--#4DEVAL i:=0-->
    <!--#4DEVAL chart_o:=OB Values(charts_o)-->

    <!--#4DLOOP (i<chart_o.length)-->
    
    var <!--#4DTEXT chart_o[i].lib-->Config = <!--#4DHTML JSON Stringify(chart_o)-->

    window.onload = function() {
        var <!--#4DTEXT chart_o[i].lib-->Chart = document.getElementById('<!--#4DTEXT chart_o[i].lib-->').getContext('2d');
        window.myLine = new Chart(<!--#4DTEXT chart_o[i].lib-->Chart, config);
    };

    <!--#4DEVAL i:=i+1-->
    <!--#4DENDLOOP-->

<!--#4DELSE-->
    data4D.debugConsole("Aucun graphique n'est initialisé dans cette page.");
<!--#4DENDIF-->
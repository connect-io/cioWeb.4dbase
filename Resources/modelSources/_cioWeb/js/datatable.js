// ----- Init de l'objet de récupération des datas 4D -----
if(data4D == null){
    var data4D = {};
}

data4D.debugConsole = function (message) {
    if (this.debugMode) {
        console.log(message);
    }
};

<!--#4DIF (dataTables_o#null)-->
    // Récupération de data 4D propre à cette page.
    data4D.dataTable_o = <!--#4DHTML JSON Stringify(dataTables_o)-->;

    <!--#4DEVAL i:=0-->
    <!--#4DEVAL dataTable_o:=OB Values(dataTables_o)-->

    <!--#4DLOOP (i<dataTable_o.length)-->
        var <!--#4DTEXT dataTable_o[i].lib--> = new Object;

        $(document).ready(function(){
            // ---- Gestion de la DOM autour du tableau -----
            <!--#4DIF (string(dataTable_o[i].dom)="auto")-->
                var dataTableDom = '<"row"<"col-12"B><"col-6"i><"col-6 g-pt-10"f>>t';

                // On affiche la pagination seulement si l'on a plus de 10 resultats.
                <!--#4DIF (dataTable_o[i].data_c.length>10)-->
                    dataTableDom += '<"row"<"col-6"l><"col-6"p>>';
                <!--#4DENDIF-->
            
            <!--#4DELSEIF (string(dataTable_o[i].dom)="forcePagination")-->
                var dataTableDom = '<"row"<"col-12"B><"col-6"i><"col-6 g-pt-10"f>>t<"row"<"col-6"l><"col-6"p>>';
            <!--#4DELSE-->
                var dataTableDom = <!--#4DTEXT dataTable_o[i].dom-->;
            <!--#4DENDIF-->
            
            <!--#4DTEXT dataTable_o[i].lib--> = $('#<!--#4DTEXT dataTable_o[i].lib-->').DataTable({
                data: <!--#4DHTML JSON Stringify(dataTable_o[i].data_c)-->,
                columns: <!--#4DHTML JSON Stringify(dataTable_o[i].column_c)-->,
                dom: dataTableDom,

                <!--#4DIF (bool(dataTable_o[i].multiSelect)=True)-->
                    select: {
                        style: 'multi+shift'
                    },
                <!--#4DENDIF-->

                "language": {
                    "url": "https://cdn.datatables.net/plug-ins/1.10.21/i18n/French.json"
                },

                // Par defaut on trie sur la 1er colonne, mais il est possible de ne pas trierle tableau au chargement.
                <!--#4DIF (bool(dataTable_o[i].noOrdering)=False)-->
                    "order": [[0, 'asc']]
                <!--#4DELSE-->
                    "ordering": false
                <!--#4DENDIF-->
            });

            // Message d'aide que le tableau est sensible au double click.
            <!--#4DIF (dataTable_o[i].doubleClick#Null)-->
                $( "<p class='help-block'>Le double clic sur une ligne permet l'accès à la fiche.</p>" ).insertAfter( ' #<!--#4DTEXT dataTable_o[i].lib-->' );
            <!--#4DENDIF--> 
            
            // ===== Gestion du double click =====
            $('#<!--#4DTEXT dataTable_o[i].lib--> tbody').on('dblclick','tr',function () {
                // On récupére, l'ID du tableau.
                var tableID = $(this).parent().parent().attr('id');

                // On récupére les data de la ligne
                var data = <!--#4DTEXT dataTable_o[i].lib-->.row( this ).data();

                <!--#4DIF (dataTable_o[i].doubleClick=Null)-->
                    data4D.debugConsole("Cet dataTable (<!--#4DTEXT dataTable_o[i].lib-->) ne contient pas d'action sur double click.");
                    return false;  
                <!--#4DELSE-->
                    var doubleClickObjet = <!--#4DHTML JSON Stringify(dataTable_o[i].doubleClick) -->;
                    var blockMaskIdNegative = Boolean(doubleClickObjet.blockMaskIdNegative);

                    if ((blockMaskIdNegative == false) || ((blockMaskIdNegative == true) && (data.maskID_t > 0))){
                        // On force le navigateur à changer une nouvelle page
                        $url = "<!--#4DTEXT dataTable_o[i].doubleClick.link-->";
                        window.location = $url.replace("maskID_t",data.maskID_t);
                    }
                <!--#4DENDIF--> 
            } );

            <!--#4DIF (bool(dataTable_o[i].multiSelect)=False)-->
                $('#<!--#4DTEXT dataTable_o[i].lib--> tbody').on( 'click', 'tr', function () {
                    // On récupére, l'ID du tableau.
                    var tableID = $(this).parent().parent().attr('id');

                    if ($(this).hasClass('selected')) {
                        $(this).removeClass('selected');
                    }else {
                        <!--#4DTEXT dataTable_o[i].lib-->.$('tr.selected').removeClass('selected');
                        $(this).addClass('selected');
                    }
                });
            <!--#4DENDIF--> 
        });

        <!--#4DIF (dataTable_o[i].ajax#Null)-->
            function <!--#4DTEXT dataTable_o[i].lib-->Reload() {
                var urlAjax = '<!--#4DTEXT dataTable_o[i].ajax.link-->?urlDataTableName=<!--#4DTEXT dataTable_o[i].lib-->';
                data4D.debugConsole('Rechargement du tableau <!--#4DTEXT dataTable_o[i].lib--> : '+urlAjax);

                <!--#4DTEXT dataTable_o[i].lib-->.clear();
                <!--#4DTEXT dataTable_o[i].lib-->.ajax.url( urlAjax ).load();
            }
        <!--#4DENDIF--> 

    <!--#4DEVAL i:=i+1-->
    <!--#4DENDLOOP-->

<!--#4DELSE-->
    data4D.debugConsole("Aucune dataTable n'est initialisé dans cette page.");
<!--#4DENDIF-->
<html>

<?php include 'head.php' ?>

<body>


<?php include 'header.php' ?>
<?php include 'banner.php' ?>

<div class="content">
    <?php
        function linkToContributor($who,$short) {
            switch($who) {
                case "rojas":
                    echo '<a href="http://www.clip.dia.fi.upm.es/~jmrojas">';
                    if($short)
                        echo "J.M. Rojas";
                    else
                        echo "Jos&eacute; Miguel Rojas Siles";
                    echo '</a>';
                    break;
                case "ortega":
                    echo '<a href="http://arantxa.ii.uam.es/~alfonso/">';
                    if($short)
                        echo "A. Ortega";
                    else
                        echo "Alfonso Ortega de la Puente";
                    echo '</a>';
                    break;
                case "cruz":
                    echo '<a href="http://arantxa.ii.uam.es/~mdlcruz/">';
                    if($short)
                        echo "M. de la Cruz";
                    else
                        echo "Marina de la Cruz Echand&iacute;a";
                    echo '</a>';
                    break;
                default:
                    echo $who;
            }
        }

        function publication($authors,$name,$link,$extra) {
            $sizeAuthors = count($authors);
            switch($sizeAuthors) {
                case 0:
                    break;
                case 1:
                    linkToContributor($authors[0],true);
                    echo '.';
                    break;
                default:
                    $sizeAuthors--; //index of de last author
                    for($i = 0; $i < $sizeAuthors; $i++) { //[0..$sizeAuthors-1]
                        linkToContributor($authors[$i],true);
                        echo ', ';
                    }
                    echo ' and ';
                    linkToContributor($authors[$sizeAuthors],true);//the last
                    echo '.';
            }
            if($extra)
                $extra = ". $extra.";
            if($link)
                echo " <a href=$link><em>$name</em></a>$extra";
            else
                echo "<em> $name</em>$extra";
        }
    ?>
    <table>
        <tr>
            <td> <br><b>jHSys</b> is a Java Splicing System Simulador developed as a joint work of 
                <?php
                    linkToContributor('rojas',0);
                    echo ', ';
                    linkToContributor('ortega',0);
                    echo ' and ';
                    linkToContributor('cruz',0);
                ?>
		.<br>
            </td>
        </tr>
        <tr>
            <td><br><b> Publications </b> :<br />
            <ol>
                <li>
                    <p>
                        <?php
                            publication(
                                array('rojas','ortega','cruz'),
                                'Towards the automatic programming of H systems: jHsys, a Java H system simulator. '
					    .'PAAMS 2010 (Special Sessions and Workshops). Pag.387-394. Advances in Soft Computing series of Springer Verlag. Volume 71. 2010.',
                                '',
                                ''
                            );
                        ?>
                    </p>
                </li>               
            </ol>
            </td>
        </tr>
    </table>
</div>
<?php
?>
<?php include 'banner.php' ?>
<?php include 'footer.php' ?>


</body>

</html>

<?php include 'config.php' ?>

<html>

<?php include 'head.php' ?>

<body>

<?php include 'header.php' ?>
<?php include 'banner.php' ?>

<?php


//$valid_ext_file = array("class", "jar","java");
//$method_me='commandAction(Ljavax/microedition/lcdui/Command;Ljavax/microedition/lcdui/Displayable;)V';
//$method_me_start='startApp()V';
//$method_se='main([Ljava/lang/String;)V';
?>

<div class="content">

<p>


<br>
<br>
<em>jHSys</em> is a research prototype that simulates a wide range of Splicing
Systems families. The tool receives as input an XML file describing
the System to be simulated and yelds as output the result of the
simulation of the system.
<br>
<br>
The jHSys web interface allows users to simulate Splicing systems
without the need of installing anything locally.
<br>
<br>
</p>

<p> <b>Select your H-System XML file:</b><br>
</p>
<form name="jhsys" action="simulate.php" method="POST" enctype="multipart/form-data">

 
  <?php
     function isXMLFile($file) {
        return substr_count($file,'.xml') == 1;
     }

     function linkToSimulation($file) {
        $path=PATH_EXAMPLES;
        echo "<a href=\"simulate.php?dir=$path&name=$file\"> Select </a>&nbsp;";
     }

     function linkToXML($file) {
        $path=PATH_EXAMPLES;
        echo "<a target=\"_new\" href=\"show_xml_file.php?path=$path$file\">XML File</a>";
     }

     function showXMLFile($file) {
        echo "<li>";
        linkToSimulation($file,'Select', PATH_EXAMPLES);
        echo "     $file   ";
        $fileName=remove_extension($file);
        echo "</li>";
     }
                
     function showExamples() {
        echo "<ul>";
        $examples=file_get_contents(EXAMPLES);
        if($examples) {
           $files = array();
           $examplefiles=split("\n",rtrim($examples));
	   if(count($examplefiles)) {
              foreach($examplefiles as $file) {
                 if(!file_exists(PATH_EXAMPLES.$file))
                    continue;
                 echo "<ul>";
                 if(isXMLFile($file))
                    showXMLFile($file);
                 else
                    echo "XML File is not well formed";
                 echo "</ul>";                       
              }
           }
           echo "</ul>";
        }
     }
  ?>
  <br>
  Provide File<input type="file" name="upload" accept="file/class" onclick="next(this.form)" >
  <input type="submit" name="action"  value="upload">
  <h3>Some Example XML Files</h3>
  <p>
    <b>
      Use "Select" to choose an example from the list. Also for every
      example, "Show XML" displays its source content.
      <br />
    </b>
  </p>
  <?php
      showExamples();
  ?>
</form>

<?php include 'banner.php' ?>
<?php include 'footer.php' ?>

</div>



</body>

</html>

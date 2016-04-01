<?php include 'config.php' ?>

<html>

    <?php include 'head.php' ?>

    <body>

        <?php
        include 'header.php';
        include 'banner.php';
        ?>
        <div class="content">
        <?php
	    $outputFile = $_POST["fileName"].".log";
	    $outputCompleteFile = TMP_WEB.$outputFile;	
	    //echo "<br>outputCompleteFile:"; var_dump($outputCompleteFile);
	    //echo "<br>realName:"; var_dump($_POST["realName"]);
            $cmd = "java -jar /home/jmrojas/public_html/jhsys/jhsys.jar ".$_POST["realName"]." ".$outputCompleteFile;

            //echo "<b>Shell command:</b><br><pre>".htmlentities($cmd)."</pre>";
	    
	    $timeout = "CPU time limit exceeded";
            echo "<pre><br><h3>Result of Simulation:</h3><br></pre>";

	    echo "<a href = \"http://www.clip.dia.fi.upm.es/~jmrojas/jhsys/tmp/web/$outputFile\">Download log file</a><br>";
	    $result = shell_exec($cmd);
            echo "<br>"; 

	    if(strncmp($result, $timeout, strlen($timeout)) == 0){
	    	echo "<pre>Sorry! ".$timeout.".</pre><br />";
	    } else {
           	$method = substr($method, 0, $pos);
            	$file = strrpos($_POST["fileName"], '/');
            	$file = substr($_POST['fileName'], $file);
            	$file = BASE_PATH.'src/tmp/testcases_'.$file.'_'.$method.'.pl';
	    }

            if(!$file_contents = @file_get_contents("$outputCompleteFile"))
            	$result = "File $outputCompleteFile could not be written.";
            else
                $result=htmlentities($file_contents);
	    echo "<pre>";
            echo $result;
	    echo "</pre>";
            echo "<br>"; 
        ?>
        </div>

        <?php include 'banner.php' ?>
        <?php include 'footer.php' ?>


    </body>

</html>

<?//set POST variables
$url = 'http://c.docverter.com/convert';
$fields = array('from' => 'latex',
		'to' => 'pdf',
		'input_files[]' => "@/".realpath('latex.latex').";type=application/x-latex; charset=UTF-8"
		);
 
//open connection
$ch = curl_init();
 
curl_setopt($ch, CURLOPT_HTTPHEADER, array("Content-type: multipart/form-data"));
curl_setopt($ch, CURLOPT_URL, $url);
curl_setopt($ch, CURLOPT_POSTFIELDS, $fields); 
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true); //needed so that the $result=curl_exec() output is the file and isn't just true/false
 
//execute post
$result = curl_exec($ch);
 
//close connection
curl_close($ch);
 
//write to file
$fp = fopen('latex_to_pdf.pdf', 'w'); //make sure the directory latex.latex is in and the latex_to_pdf.pdf will go to has proper permissions
fwrite($fp, $result);
fclose($fp);
?>
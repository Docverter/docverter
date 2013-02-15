<?//set POST variables
$url = 'http://c.docverter.com/convert';
$fields = array('from' => 'markdown',
		'to' => 'pdf',
		'input_files[]' => "@/".realpath('markdown.md').";type=text/x-markdown; charset=UTF-8"
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
$fp = fopen('uploads/result.pdf', 'w'); //make sure the directory markdown.md is in and the result.pdf will go to has proper permissions
fwrite($fp, $result);
fclose($fp);
?>
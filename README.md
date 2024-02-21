# PipelineCount

<ul>
  <li>This Project is designed to return all the CI pipeline Count Created in 3-months time </li>
  <li>This project uses <b>rest api</b> to fetch all the <b>Project Name</b> in your organisation and return its pipeline count</li>
  <br>
  <li>This Project will generate two CSV files :</li>
  <ol type="1">
    <li>count-pipeline-<Environment-Name>.csv : This file contains the name of pipeline and count of CI pipeline created in 3 months Time</li>
      <li>project-pipeline-count<Environment-Name>.csv : This file contains the name of Project and name of its pipeline to cross-verify it </li>
        <li>The output console will also print the same, but these file would we easy to track the Output</li>
  </ol>
      <li>Working of this Script</li>
        - In my case I has two url link https://dev.azure.com/Utsav-HE && https://dev.azure.com/Utsav-DEV.
        <br>
        - So I had variablelised the HE and DEV environments depending on which env I want output I will enter that.
        <br>
        - Then Enter the pat-token, the Code will generate its output file
</ul>

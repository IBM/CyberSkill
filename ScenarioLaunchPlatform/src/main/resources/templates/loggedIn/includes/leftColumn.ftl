<div class="w3-col m3">
      <!-- Profile -->
      <div class="w3-card w3-round w3-white">
        <div class="w3-container">
         <h4 class="w3-center">${tokenObject.username}</h4>
         <p class="w3-center"><img src="/w3images/avatar3.png" class="w3-circle" style="height:106px;width:106px" alt="Avatar"></p>
         <hr>
         <p><i class="fa fa-pencil fa-fw w3-margin-right w3-text-theme"></i> DemoTeam, UI</p>
         <p><i class="fa fa-home fa-fw w3-margin-right w3-text-theme"></i> Dublin, IRE</p>
         <p><i class="fa fa-birthday-cake fa-fw w3-margin-right w3-text-theme"></i> Oct 1, 2024</p>
        </div>
      </div>
      <br>
      
      <!-- Accordion -->
      <div class="w3-card w3-round">
        <div class="w3-white">
          <button onclick="myFunction('Demo1')" class="w3-button w3-block w3-theme-l1 w3-left-align"><i class="fa fa-circle-o-notch fa-fw w3-margin-right"></i> Connections</button>
          <div id="Demo1" class="w3-hide w3-container">
            	<#if ValidatedConnectionData?has_content>
		            <#list ValidatedConnectionData?keys as key>
		                <li>${key}</li>
		            </#list>
	            <#else>
                	No connections
            	</#if>
          </div>
          <button onclick="myFunction('Demo2')" class="w3-button w3-block w3-theme-l1 w3-left-align"><i class="fa fa-bolt fa-fw w3-margin-right"></i> API Access</button>
          <div id="Demo2" class="w3-hide w3-container">
           <a href="/swagger-ui/index.html" target="_blank"><i class="fa fa-link" aria-hidden="true"></i>Swagger</a>  
          </div>
          <button onclick="myFunction('Demo3')" class="w3-button w3-block w3-theme-l1 w3-left-align"><i class="fa fa-book fa-fw w3-margin-right"></i> Documentation</button>
          <div id="Demo3" class="w3-hide w3-container">
           <a href="/loggedIn/documents/SLPHandbook.pdf" target="_blank"><i class="fa fa-link" aria-hidden="true"></i>SLP handbook</a>
         <div class="w3-row-padding">
         <br>
           <div class="w3-half">
             
           </div>
           
         </div>
          </div>
        </div>      
      </div>
      <br>
      
      <!-- Interests --> 
      <div class="w3-card w3-round w3-white w3-hide-small">
        <div class="w3-container">
          <p>Query Types</p>
          <p id="queryTypes">
        
          </p>
        </div>
      </div>
      <br>
      
      <!-- Alert Box -->
      <div class="w3-card w3-round w3-white w3-padding-16 w3-center">
        <p>Suggestion box</p>
      </div>
      <br>
      
      <div class="w3-card w3-round w3-white w3-padding-32 w3-center">
        <p><i class="fa fa-bug w3-xxlarge"></i></p>
      </div>
      
      
 <script>
    $(document).ready(function() 
  	{
  		getQueryTypes();
  	
  	
  	});
    function getQueryTypes()
		{
			
			
			const var_jwt = '${tokenObject.jwt}';
		  
		  	const jsonData = JSON.stringify({
		  		  jwt:var_jwt,
		  		});
		  
		  	console.log(jsonData);
		  
		  
			$.ajax({
		          url: '/api/getQueryTypes', 
		          type: 'POST',
		          data: jsonData,
		          contentType: 'application/json; charset=utf-8', // Set content type to JSON
		          success: function(response) 
		          {
		             	const queryTypes = document.getElementById('queryTypes');
		             	queryTypes.innerHTML = "";
		             	console.log(response);
		             	
		             	if (Array.isArray(response)) 
		             	{
      				      $.each(response, function(index, item) 
					      {
					        console.log(index, item);  
					        const span = document.createElement('span');
							span.textContent = item.query_type;
							span.classList.add('w3-tag');
							span.classList.add('w3-small');
							span.classList.add('w3-theme-d'+index);
							
							span.onclick = function() {
                					console.log("Redirecting for: "+ item.query_type);
                					window.location.href='databases.ftl?lookup='+ item.query_type;
            				};
							queryTypes.appendChild(span);
					      });
						}             	
		             	
		             	
		             	
		             	
		          },
		          error: function(xhr, status, error) 
		          {
		            $('#response').text('Error: ' + error);
		          }
		        });
		
		}
      </script>
      
      
      
      
      
      
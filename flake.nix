{
  inputs = { flake-utils.url = "github:numtide/flake-utils"; } ;
  outputs =
    { self , flake-utils } :
      flake-utils.lib.eachDefaultSystem
      (
        system :
          let
            argue =
	      {
	        input ,
	        input-tests ,
		label ,
		lambda ,
		output-tests ,
		to-string
	      } :
	        let
		  concat-strings = value : builtins.concatStringsSep " ,\n" ( builtins.concatLists [ [ ticket ] value ] ) ;
		  input-test-results =
		    if builtins.typeOf input-tests != "list" then { success = false ; value = [ "bf3b0642-c6bc-4e03-b045-62ca169e0971" ] ; }
		    else if builtins.typeOf lambda != "lambda" then { success = false ; value = [ "32005f68-baee-4808-ba11-9165d48f2065" ] ; }
		    else
		      let
		        mapper =
			  test :
			    if builtins.typeOf test != "list" then { success = false ; value = [ "b3fd16fa-4d6e-4278-962c-93df5071b170" ] ; }
			    else if builtins.length test != 4 then { success = false ; value = [ "a5abc1e0-3f8f-4779-9fda-c4d65f8da62d" ] ; }
			    else if builtins.typeOf ( builtins.elemAt test 1 ) != "bool" then { success = false ; value = [ "2a4a2d56-4f25-4d19-bdc7-e05af98e6389" ] ; }
			    else if builtins.typeOf ( builtins.elemAt test 3 ) != "string" then { success = false ; value = [ "1a5b6a81-bbe3-4c67-9911-c20dcc91ba76" ] ; }
			    else
			      let
			        eval = builtins.tryEval ( lambda ( builtins.elemAt test 0 ) ) ;
				success = eval.success == builtins.elemAt test 1 ;
				value =
				  if ! success then [ builtins.elemAt test 3 ]
				  else if ! eval.success then [ builtins.elemAt test 3 ]
				  else [ ] ;
				in { success = success ; value = value ; } ;
			in test input-tests mapper "2993696e-6e89-41b8-a61a-98ce44b944c4" ;
		  output =
		    if ! input-test-results.success then input-test-results
		    else builtins.tryEval lambda input ;
		  output-test-results =
		    if ! output.success then output
		    else if builtins.typeOf output-tests != "list" then { success = false ; value = [ "84e71639-2a1b-433a-8629-30e7c6b212db" ] ; }
		    else
		      let
		        mapper =
			  test :
			    if builtins.typeOf test != "list" then { success = false ; value = [ "cf9d7aa2-b282-43fa-aa1c-8e29e9ec4dc9" ] ; }
			    else if builtins.length test != 2 then { success = false ; value = [ "862bd498-e4bf-4d93-9834-78abf60e88b5" ] ; }
			    else if builtins.typeOf ( builtins.elemAt test 0 ) != "lambda" then { success = false ; value = [ "ac4c3793-77b8-4126-8c89-66e74795fcbc" ] ; }
			    else if builtins.getAttr "success" ( builtins.tryEval ( builtins.elemAt test 0 input ) ) then { success = false ; value = [ "6b10b5e8-c6d2-4c15-8ad8-37f16da70efd" ] ; }
			    else if builtins.typeOf ( builtins.elemAt test 0 input ) != "lambda" then { success = false ; value = [ "4cb01f27-b533-40a5-952a-461c02d6f00c" ] ; }
			    else if builtins.getAttr "success" ( builtins.tryEval ( builtins.elemAt test 0 input output.value ) ) then { success = false ; value = [ "96fc5f0b-86ec-49d5-be4a-2de825abbc37" ] ; }
			    else if builtins.typeOf ( builtins.elemAt test 0 input output.value ) != "bool" then { success = false ; value = [ "262789d3-7d59-47e0-90cd-8b0b349a6268" ] ; }
			    else if builtins.elemAt test 0 input output.value != builtins.elemAt test 1 then { success = false ; value = [ ( builtins.elemAt test 1 ) ] ; }
			    else { success = true ; value = output.value ; } ;
			in test output-tests mapper "05e2eedd-cb28-4d01-b602-9d3d7665c0c6" ;
		  string =
		    if output-test-results.success == false then output-test-results
		    else if builtins.typeOf to-string != "lambda" then { success = false ; value = [ "205824d2-14b7-4290-9081-99702b5299fd" ] ; }
		    else if ! builtins.getAttr "success" ( builtins.tryEval ( to-string output.value ) ) then { success = false ; value = [ "843ac714-0f10-4c58-acac-20ba483d7725" ] ; }
		    else if builtins.typeOf ( to-string output.value ) != "string" then { success = false ; value = [ "f9fcf542-5870-496d-9403-b7459dc63fa3" ] ; }
		    else builtins.tryEval ( to-string output.value ) ;
	          test =
		    results : mapper : error :
		      if builtins.typeOf results != "list" then { success = false ; value = [ error ] ; }
		      else
		        let
			  mapped = builtins.map mapper results ;
			  success = builtins.all ( test : test.success ) mapped ;
			  value = builtins.concatLists ( builtins.map ( test : test.value ) mapped ) ;
			  in { success = success ; value = value ; } ;
		  ticket = if builtins.typeOf label == "string" then label else "648c4ec2-8287-455e-8bc1-4b2de45b0b4e" ;
		  in
		    {
		      object = if output-test-results.success then output.value else builtins.throw ( concat-strings output-test-results.value ) ;
		      test = if builtins.length input-test-results.value == 0 then "PASSED" else ( builtins.toString ( builtins.typeOf ( builtins.elemAt input-test-results.value 1 ) ) ) ;
		      trace =
		        if string.success then builtins.trace string.value output.value
			else if output-test-results.success then builtins.trace string.value output.value
			else builtins.throw ( concat-strings output-test-results.value ) ;
		    } ;
            in { lib = argue ; }
      ) ;
}

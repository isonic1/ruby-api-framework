# Ruby API Automation Example

Repository: git@github.com:isonic1/ruby-api-framework.git

***Install Dependencies:***

***Mac: >>>>>> Never EVER EVER sudo install anything!!! <<<<<<***

1. Install RVM and Ruby: ```\curl -sSL https://get.rvm.io | bash -s stable –ruby```

	a. Run: ```rvm list```

	b. Run: ```rvm --default use 2.2.?``` to set the version as default.

2. Install bundler: ```gem install bundler```

3. Clone the repo: ```git clone git@github.com:isonic1/ruby-api-framework.git```

4. Go into repo: ```cd ruby-api-framework```

5. Run: ```ruby dependencies.rb```

6. The above bundle install should install all framework dependencies.

***Windows:*** 

1. Download and install Ruby 64-bit or 32-bit

	a. Make note of the installation/destination path! e.g. c:\Ruby22-x64\bin

	b. Goto Control Panel\System and Security\System > Advanced system > Edit Variables...

	c. Under "User variables for your_user_name"

	d. Add path for ruby location. e.g. c:\Ruby22-x64\bin
	
	e. Click OK 

2. Download and install Ruby Developer Kit 32-bit or 64-bit

	a. Extract the files to c:\ruby-dev-kit

	b. Open a power shell terminal and run as administrator.

	c. goto ```cd c:\ruby-dev-kit```

	d. Run: ```ruby dk.rb init```

	e. Run: ```ruby dk.rb install```
	
	f. Test the installation by running: ```gem install json --platform=ruby --source http://rubygems.org``` in CMD. You should see "1 gem installed" if all goes well.
       
	g. The above json gem should install successfully.

3. Install bundler: ```gem install bundler``` 

4. Clone the repo: ```git clone git@github.com:isonic1/ruby-api-framework.git```

5. Go into repo: ```cd ruby-api-framework```

6. Run: ```ruby dependencies.rb```

7. The above ruby script will install all framework dependencies.

***Run a test:***

* Note: This example uses [THIS EXAMPLE API](https://jsonplaceholder.typicode.com/). The POSTs, DELETE and PUTS just simulate these actions and do not work. So that is why you will see failures for the tests on these actions.
* Look at the comments in each spec to give you more specifics on what things do and recommendations...

1. Go into repo: ```cd ruby-api-framework```

2. Run all tests: ```rspec spec```

3. Run individual test: ```rspec spec/posts_spec.rb```

* You should see tests running after.

*** PREFERRED RUN METHOD ***

4. Use the runner.rb script.
    * `$ ruby runner.rb specs (list all specs)`
    * `$ ruby runner.rb (Run all specs)`
    * `$ ruby runner.rb posts (runs all posts tests)`
    * `$ ruby runner.rb parallel (runs all specs in parallel using parallel_rspec gem. Merges html reports into one afterward!)`
    * `$ ruby runner.rb failures (Reruns failures from previous test run via failures.txt)`

***Test Results:***

1. Html report: ruby-api-framework/output/rspec.html

2. Json report: ruby-api-framework/output/rspec.json (You can use this json output to create your own reports or feed it into an existing reporting framework)

3. When tests are run in parallel, by default parallel_rspec generates a report for every process. e.g. rspec.html ... rspec2.html etc... I created a script "merge_reports.rb" to combine all reports into one "rspec.html" after the tests complete.

4. Rspec has a bug when using `--color` with adding ascii characters to the html report. I created a new html formatter to fix this issue. Additionally, I capture the full request path on every api call and print it inside the report on failures. I also modified the html snippet extractor to capture the entire test so you dont have to open the framework to see all the logic of what the test was doing.
    * See the .rspec, .rspec_parallel, and spec_helper.rb files for rspec settings.
    
***Debugging with IRB: (Interactive Ruby REPL)***

* Use pry "binding.pry" in the code to put the framework into IRB with loaded classes and variables. 
* See spec/post_specs.rb for examples. Though this can be placed in any ruby file to set a break point at any point.

***Adding a Test***

* Add new tests in the spec folder with _spec.rb. e.g. mytest_spec.rb
* I like to use the `it { expect() matcher }` technique. Since you can have multiple assertions not tied to a single context. If one assertion fails then the others are still checked. Otherwise, if one expect (assertion) fails the entier test fails without ever checking the other assertions. 

### TODO:
* Show examples on how to set an API Key.
* Show examples on how to use OAUTH.
* Show examples on how to add Headers.

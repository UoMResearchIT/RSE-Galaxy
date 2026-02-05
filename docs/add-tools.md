# Adding tools to the toolbox

This guide will help you add tools to your Galaxy instance. The stages of tool creation are as follows:
- Create a directory for holding the tool
- Create a `tool.xml` file
- Add the tool to the `tool_conf.xml` file
- Test the tool in Galaxy, and debug if necessary

## Create a directory for holding the tool

To add a tool to your Galaxy instance, in this repository you will need to create a directory in the `galaxy/tools` directory. This directory will hold the tool file and any other files that are needed for the tool to run.

You can create a directory for your tool by running the following command:

```bash
mkdir -p galaxy/tools/my_tool
```

## Create a `tool.xml` file

The `tool.xml` file is the configuration file for the tool. This file tells Galaxy how to run the tool, what parameters the tool requires, what outputs the tool produces, and how to display the tool in the Galaxy interface.

```bash
nano galaxy/tools/my_tool/tool.xml # or use your preferred text editor
```

Here is an example `tool.xml` file (the `letter_count` tool):

```xml
<tool id="letter_count" name="Letter Count" version="0.1.0">
  <description>Counting letters in a string</description>
  
  <requirements>
    <container type="docker">python:3.13-slim</container>
  </requirements>
  
  <command>
    <![CDATA[
      python '$__tool_directory__/letter_count.py' '$input_file' '$output_file'
    ]]>
  </command>

  <inputs>
    <param type="data" name="input_file" label="Input File" help="Enter the file (containing a sentence) to count the letters" />
  </inputs>

  <outputs>
    <data format="csv" name="output_file" label="Letter Count" help="Output file containing the letter count" />
  </outputs>

  <tests>
  <test expect_exit_code="0">
      <param name="input_file" value="input.txt"/>
      <output name="output_file" file="output.csv">
      </output>
  </test>
  </tests>
  
  <help>
    This tool counts the number of letter in each word of a file.
  </help>

</tool>
```

Let's break this down.

---

```xml
<tool id="letter_count" name="Letter Count" version="0.1.0">
  <description>Counting letters in a string</description>
```

These sections provide metadata for the tool and helpful information for the user. The tool id must be unique and is used to reference the tool in the `tool_conf.xml` file.

---

```xml
  <requirements>
    <container type="docker">python:3.13-slim</container>
  </requirements>
```

This section is optional but very common, it specifies the container that the tool will run in. This is useful for ensuring that the tool runs in a consistent environment.

---

```xml
  <command>
    <![CDATA[
      python '$__tool_directory__/letter_count.py' '$input_file' '$output_file'
    ]]>
  </command>
```

This section specifies the command that will be run when the tool is executed. The `__tool_directory__` variable is a special variable that points to the directory where the tool is located. The `input_file` and `output_file` variables are placeholders for the input and output files.

---

```xml
  <inputs>
    <param type="data" name="input_file" label="Input File" help="Enter the file (containing a sentence) to count the letters" />
  </inputs>
```

This section specifies the inputs that the tool requires. In this case, the tool requires a file as input.

---

```xml
  <outputs>
    <data format="csv" name="output_file" label="Letter Count" help="Output file containing the letter count" />
  </outputs>
```

This section specifies the outputs that the tool produces. In this case, the tool produces a CSV file.

---

```xml
  <tests>
  <test expect_exit_code="0">
      <param name="input_file" value="input.txt"/>
      <output name="output_file" file="output.csv">
      </output>
  </test>
  </tests>
```

This section specifies tests for the tool, to ensure that it works as expected given some known inputs. The test inputs (and reference outputs, if any) should be placed in a `test-data` directory next to the tool XML. It is possible to define "looser" tests that check for properties of the output rather than exact matches.  See [word_count.xml](../galaxy/tools/examples/wc/word_count.xml) for a simple example, and the Galaxy [tool schema docs](https://docs.galaxyproject.org/en/master/dev/schema.html#tool-tests) for details.

---

```xml
  <help>
    This tool counts the number of letter in each word of a file.
  </help>
```

This section provides help text for the tool.

---

By replicating and customising this template, you can create a tool for your Galaxy instance.

## Add the tool to the `tool_conf.xml` file

The `tool_conf.xml` file is the configuration file for Galaxy that tells Galaxy where to find the tools. You will need to add the path to the `tool.xml` file in the `tool_conf.xml` file.

```bash
nano galaxy/config/tool_conf.xml # or use your preferred text editor
```

Add the following line to the `tool_conf.xml` file:

```diff
  <section id="examples" name="Example Tools">
    <tool file="examples/wc/word_count.xml" />
    <tool file="examples/lc/letter_count.xml" />
    <tool file="examples/hist/hist.xml" />
+   <tool file="my_tool/tool.xml" />
  </section>
```
  
This line tells Galaxy to include the tool in the `my_tool` directory in the `Example Tools` section. Feel free to customise the section name and location of the tool, or create a new section for your tool.

## Test the tool in Galaxy, and debug if necessary

To test the tool in Galaxy, you will need to restart the Galaxy instance. You can do this by running the following command:

```bash
docker compose down
docker compose up -d
```

You can now access Galaxy by navigating to `http://localhost:80` in your web browser. You should see the tool in the `Example Tools` section. You can run the tool by clicking on the tool name and following the instructions.

If you find that the tool does not work as expected, you can check the logs by running:

```bash
docker ps # to get the container ID
docker exec -it <container_id> bash
# galaxyctl follow
```
  
To run the unit tests defined in the tool XML, trigger the optional `tool-tests` service in the `docker-compose.yml` file:

```bash
docker compose up tool-tests
```

During development, you can run tests from a local `planemo` installation against your running Galaxy instance using a command like:

```sh
uv tool run planemo test \
  --engine external_galaxy \
  --galaxy_url 'http://localhost' \
  --galaxy_admin_key $GALAXY_API_KEY \
  path/to/tool.xml
```

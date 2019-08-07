# What is this for

This directory contains all the code and information pertaining to the Parser that will take in `master-openapi.json` and write multiple `.json` file based on the specification of the `oas.yml`

## Technical Flow for Parser

1. Read `master-openapi.json` in `../react-page/src/oas_spec/master-openapi.json` as `master_oas_json` and `oas.yml` in `/config` as `oas_config`.
  - If you wish to change the name or path of file, edit this `ruby-parser/lib/tasks/generate.rake`
2. `master_oas_json` and `oas_config` are used to initialize `MainController` which act as the driver class for `rake generate`
3. `master_oas_json` and `oas_config` are also used to initialize `ParserController`
4. `add_paths` will be executed first to select specificed paths in `oas_config` from `master_oas_json` and add to an empty json(`@curr_oas`)
5. `add_general_info` will then add `"openapi", "servers", "info", "tags", "externalDocs", "components"` objects to `@curr_oas`. These objects are non client/specific and will be rendered to all documents
6. `process_tags` will then iterate through all the newly selected `paths` object to identify the tags associated with the path. A list is created to store all the unique tags for that particular document. Afterwards, the method will iterate through the `tags object` of `master_oas_json`(contain all tags) and remove any tags that is not in the list or does not contain the field `x-traitTag`
7. `process_params` will iterate through all the parameter for all the selected paths and check for the presence of `x-custom-params`. If there is this field and the name of the document it is generating for does not tally with the name in this field, the object will be deleted and that parameter will not be present.
8. `process-requestBody` will then iterate through all the requestBody for all the selected paths and check:
- For the presence of `x-custom-params-requirements` field. If there is this field and the name of the document it is generating for tallies with the name stated in the value of `x-custom-params-requirements`, the array in the value will append to the array in `required: `
- For the presence of `x-custom-params`. If there is this field and the name of the document it is generating for does not tally with the name in this field, the object will be deleted and that parameter will not be present.
9. `generate_file` will write `@curr_oas` as a json file in `react-page/src/oas_spec`. At this point in time the document has been created successfully

## Things to note
1. All methods will make a copy of the object at the begining of reduce the chance of any bug occurring due to different references pointing to the same instance of an object
2. All methods will return a new `ParserController` to promote statelessness. This will allow for method chaining and standardization among the methods.

### Other Thoughts
- Initially the paths object for `master-openapi.json` were stored in a Treee Data Structure. The motivation behind this was to optimize the documentation generating process especially when we use `/pathABC*` in oas.yml. This will allow us to narrow down the paths with `/pathABC*` in O(1) time(best scenario) by travelling the tree. From there select all the objects that are the children of `/pathABC`. A working code for this approach can be viewed on `Parser_Tree_Approach` but it was not adopted as it would be too confusing to handover. Visual representation of approach [here](https://www.lucidchart.com/invitations/accept/9b582315-4c29-46a4-ac7d-61cb3394a662).

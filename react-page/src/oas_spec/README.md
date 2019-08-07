All OAS definition in JSON will live in this directory. 

`master-openapi.json` is the master OAS definition of Xfers' API and is written manually.
`Singapore.json` and `Indonesia.json` is the client specific document written by `rake generate`
`template.json` is a template for Xfers' internal use. Copy and paste the code from template if you wish to add an endpoint quickly

1. Make changes that will affect all documents(Single Source of Truth) make changes to `master-openapi.json`. Parser will generate specific API documentation based on this `json` file.
    - The document rendered in url/#/master is powered by this `json` file.
2. If you wish to make manual changes(ie ordering of endpoints/tags) to client specific documents, you can change the code in `Singapore/Indonesia.json`. Make sure you do not run `rake generate` as it would overwrite your work.
    - documentation on `url/#/` is powered by these file. Any changes made to the files will be seen immediately on the website.
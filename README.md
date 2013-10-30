# parsecom-import

You can import an exported zip file into your parse.com app.

## Installation

    $ gem install parse-importer

If you are using rbenv, please don't forget call rehash

    $ rbenv rehash

## Usage

Set environment variables to connect parse.com

    export PARSE_APPLICATION_ID="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    export PARSE_API_KEY="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    export PARSE_MASTER_KEY="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

Call parse-import command.

    $ parse-import 50523f10-2b8a-4bb8-83ef-31d2fa71f82d_1585107803_export.zip

## Note

The behavior of this command is different from exporting json files on the web. Though exporting on the web is allowed to set objectId and other reserved columns, this command is not. In short, this command changes objectIds and cannot copy some reserved columns.

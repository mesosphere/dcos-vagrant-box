# Release Process

1. Clone or checkout dcos-vagrant-box master branch
1. Build (TeamCity)

    ```
    export BOX_VERSION=<version>
    ci/build_release.sh
    ```

    1. Builds a new version of the box with Packer
    1. Exports the box as a build artifact
1. Upload (TeamCity)

    ```
    export AWS_ACCESS_KEY_ID=<key-id>
    export AWS_SECRET_ACCESS_KEY=<secret-key>
    export BOX_VERSION=<version>
    ci/upload_release.sh
    export BOX_DESC='<short-description-of-changes-in-markdown>'
    ci/update_catalog.sh
    ```

    1. Imports the box artifact
    1. Uploads the box to S3
    1. Modifies the Vagrant Box Catalog Metadata (metadata.json) to add the new box metadata
    1. Pushes the Box Catalog changes as a new release candidate git branch
1. Test (Manual)

    The following steps should be performed for each supported DC/OS release (stable + EarlyAccess + continuous) for each supported version of dcos-vagrant (last release + head of master).
    1. Clone or checkout [dcos-vagrant](https://github.com/mesosphere/dcos-vagrant)
    1. Configure dcos-vagrant to use the modified Box Catalog

        ```
        export DCOS_BOX_URL=file://~/workspace/dcos-vagrant-box/metadata.json
        ```
    1. Download the latest DC/OS release
    1. Configure dcos-vagrant to use the latest release

        ```
        export DCOS_GENERATE_CONFIG_PATH=dcos_generate_config-<version>.sh
        export DCOS_CONFIG_PATH=etc/config-<version>.yaml
        ```
    1. Run through the [dcos-vagrant examples](https://github.com/mesosphere/dcos-vagrant/tree/master/examples)
1. Publish (TeamCity)

    ```
    export AWS_ACCESS_KEY_ID=<key-id>
	export AWS_SECRET_ACCESS_KEY=<secret-key>
	export BOX_VERSION=<version>
    ci/publish_release.sh
    ```

    1. Checks out the release candidate branch
    1. Uploads the Box Catalog to S3
    1. Checks out the master branch
    1. Merges the release candidate branch to master
    1. Deletes the release candidate branch
    1. Creates a new release tag from head of master

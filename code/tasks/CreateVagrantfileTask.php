<?php

class CreateVagrantfileTask extends BuildTask
{
    protected $title = 'Create vagrantfile';

    protected $description = 'Creates a Vagrantfile in your root directory, so that you can perform local development by having vagrant and virtualbox installed.';

    /**
     * Run task
     *
     * @param $request
     */
    function run($request) {
        $vagrant = Vagrantfile::create();

        return $vagrant->render();
    }
}

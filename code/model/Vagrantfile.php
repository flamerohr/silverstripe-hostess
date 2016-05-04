<?php

/**
 * Vagrantfile class for customisations to the vagrant file generated
 */
class Vagrantfile extends ArrayData
{
    private static $name = 'silverstripe_localhost';

    private static $base_url = 'localhost.dev';

    private static $ip = '192.168.10.15';

    private static $box = 'micmania1/silverstripe-jessie64';

    private static $post_script = '';

    private static $template = 'Vagrantfile';

    public function render() {
        $data = array(
            'BaseUrl' => $this->config()->base_url,
            'Box' => $this->config()->box,
            'Ip' => $this->config()->ip,
            'Name' => $this->config()->name,
            'PostScript' => $this->config()->post_script,
        );

        $this->array = array_merge($data, $this->array);

        return $this->renderWith($this->config()->template);
    }
}

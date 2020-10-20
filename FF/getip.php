<?php

class Request
{

    /**
     * Retrieves IP address set in the request header.
     *
     * Each ISPs sets them following their own logic. There is also a possibility for the user
     * to easily spoof their IP address.
     *
     * So using this for mission critical situations is not advisable.
     * If you are getting the IP address for casual logging purposes, then this is fine.
     */
    public function getIpAddress()
    {
        $ipAddress = '127.0.0.1';
        if (! empty($_SERVER['HTTP_CLIENT_IP']) && $this->isValidIpAddress($_SERVER['HTTP_CLIENT_IP'])) {
            // check for shared ISP IP
            $ipAddress = $_SERVER['HTTP_CLIENT_IP'];
        } else if (! empty($_SERVER['HTTP_X_FORWARDED_FOR'])) {
            // check for IPs passing through proxy servers
            // check if multiple IP addresses are set and take the first one
            $ipAddressList = explode(',', $_SERVER['HTTP_X_FORWARDED_FOR']);
            foreach ($ipAddressList as $ip) {
                if ($this->isValidIpAddress($ip)) {
                    $ipAddress = $ip;
                    break;
                }
            }
        } else if (! empty($_SERVER['HTTP_X_FORWARDED']) && $this->isValidIpAddress($_SERVER['HTTP_X_FORWARDED'])) {
            $ipAddress = $_SERVER['HTTP_X_FORWARDED'];
            
            
        } else if (! empty($_SERVER['HTTP_X_CLUSTER_CLIENT_IP']) && $this->isValidIpAddress($_SERVER['HTTP_X_CLUSTER_CLIENT_IP'])) {
            
            $ipAddress = $_SERVER['HTTP_X_CLUSTER_CLIENT_IP'];
            
            
        } else if (! empty($_SERVER['HTTP_FORWARDED_FOR']) && $this->isValidIpAddress($_SERVER['HTTP_FORWARDED_FOR'])) {
            $ipAddress = $_SERVER['HTTP_FORWARDED_FOR'];
            
            
        } else if (! empty($_SERVER['HTTP_FORWARDED']) && $this->isValidIpAddress($_SERVER['HTTP_FORWARDED'])) {
            $ipAddress = $_SERVER['HTTP_FORWARDED'];
            
            
        } else if (! empty($_SERVER['REMOTE_ADDR']) && $this->isValidIpAddress($_SERVER['REMOTE_ADDR'])) {
            $ipAddress = $_SERVER['REMOTE_ADDR'];
            
        }
        return $ipAddress;
    }

    /**
     * To validate if an IP address is both a valid and does not fall within
     * a private network range.
     *
     * @access public
     * @param string $ip
     */
    public function isValidIpAddress($ip)
    {
        if (filter_var($ip, FILTER_VALIDATE_IP, FILTER_FLAG_IPV4 | FILTER_FLAG_IPV6 ) === false) {
//            | FILTER_FLAG_NO_RES_RANGE
//            | FILTER_FLAG_NO_PRIV_RANGE 
            return false;
        }
        return true;
    }

}
/*  Notification [Common Notification]
*
*	Author(s): Jason Flood/John Clarke
*  	Licence: Apache 2
*  
*   
*/


package manager.thejasonengine.com;

import java.io.Serializable;

import io.micrometer.prometheus.PrometheusMeterRegistry;

public class Admin implements Serializable 
{
	public PrometheusMeterRegistry prometheusRegistry;
	public Admin() {}
	
	public Admin(PrometheusMeterRegistry prometheusRegistry) 
    {
        this.prometheusRegistry = prometheusRegistry;
    }
	
    private static final long serialVersionUID = 1L;

	
	
	public PrometheusMeterRegistry getPrometheusRegistry() {
		return prometheusRegistry;
	}

	public void setPrometheusRegistry(PrometheusMeterRegistry prometheusRegistry) {
		this.prometheusRegistry = prometheusRegistry;
	}
	
}

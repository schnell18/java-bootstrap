[%- SET async  = comp.get_part("gwt_rpc_service_async_class") -%]
package [% comp.service_interface_package %];

import com.google.gwt.user.client.rpc.RemoteService;
import com.google.gwt.user.client.rpc.RemoteServiceRelativePath;

@RemoteServiceRelativePath("[% comp.servlet_path %]")
public interface [% async.class_name %] extends RemoteService {
    void yourMethod(String yourArg);
}

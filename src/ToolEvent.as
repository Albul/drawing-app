/**
 * Created by abdula on 15.07.2015.
 */
package {
import flash.events.Event;

public class ToolEvent extends Event {

	public static var TRASH_CLICKED:String = "trashClicked";
	public static var SAVE_CLICKED:String = "saveClicked";
	public static var TOOL_SELECTED:String = "toolSelected";

	private var _tool:int;

	public function ToolEvent(type:String, tool:int = -1) {
		super(type, false, false);
		_tool = tool;
	}

	public function get tool():int {
		return _tool;
	}
}
}

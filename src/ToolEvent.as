/**
 * Copyright (c) 2011-2012 Alexandr Albul
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package {
import flash.events.Event;

public class ToolEvent extends Event {

	public static var SUB_PANEL_OPENED:String = "subPanelOpened";
	public static var TRASH_CLICKED:String = "trashClicked";
	public static var SAVE_CLICKED:String = "saveClicked";
	public static var TOOL_SELECTED:String = "toolSelected";
	public static var THICKNESS_CHANGED:String = "thicknessChanged";
	public static var COLOR_CHANGED:String = "colorChanged";

	private var _tool:int;
	private var _thickness:int;
	private var _color:uint;
	private var _alpha:Number;

	public function ToolEvent(type:String, tool:int = -1, thickness:int = 1, color:uint = 0xFFFFFF, alpha:Number = 1) {
		super(type, true, false);
		_tool = tool;
		_thickness = thickness;
		_color = color;
		_alpha = alpha;
	}

	public function get tool():int {
		return _tool;
	}

	public function get thickness():int {
		return _thickness;
	}

	public function get color():uint {
		return _color;
	}

	public function get alpha():Number {
		return _alpha;
	}
}
}

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

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;

import view.ToolPanel;

public class Main extends Sprite {

	private var _toolPanel:ToolPanel;
	private var _board:Sprite;
	private var _drawingController:DrawingController;

	public function Main() {
		if (stage) {
			init();
		} else {
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}

	private function init(event:Event = null):void {
		removeEventListener(Event.ADDED_TO_STAGE, init);

		stage.align = StageAlign.TOP_LEFT;
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.addEventListener(Event.RESIZE, resizeHandler);

		_board = new Sprite();
		addChild(_board);

		_toolPanel = new ToolPanel();
		addChild(_toolPanel);
		_toolPanel.init();

		_drawingController = new DrawingController(_toolPanel, _board);
		resizeHandler();
	}

	private function resizeHandler(event:Event = null):void {
		_toolPanel.drawBg();
		_board.x = _toolPanel.width;
		_board.graphics.beginFill(Constants.WHITE_COLOR, 1);
		_board.graphics.drawRect(0, 0, stage.stageWidth - _toolPanel.width, stage.stageHeight);
		_board.graphics.endFill();
	}
}
}

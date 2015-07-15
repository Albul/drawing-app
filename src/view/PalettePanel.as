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
package view {
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Point;

public class PalettePanel extends DropRightPanel {

	[Embed(source='../../assets/palette.png')] private static const PaletteImg:Class;

	//--------------------------------------
	//  Private members
	//--------------------------------------

	private var _mainButton:Sprite;
	private var _paletteBmpData:BitmapData;

	//--------------------------------------------------------------------------
	//
	//  Public methods
	//
	//--------------------------------------------------------------------------

	public function PalettePanel() {
		super();
	}

	public function init():void {
		_mainButton = new Sprite();
		_mainButton.buttonMode = true;
		colorizeButton(_mainButton, Constants.BLACK_COLOR);
		addChild(_mainButton);
		_mainButton.addEventListener(MouseEvent.CLICK, mainButton_clickHandler);

		_dropRightPanel.x = _mainButton.width;

		_paletteBmpData = new PaletteImg().bitmapData;
		var paletteBmp:Bitmap = new Bitmap(_paletteBmpData);
		_dropRightPanel.addChild(paletteBmp);
		_dropRightPanel.x = Constants.TOOL_PANEL_WIDTH;
		_dropRightPanel.y = parent.localToGlobal(new Point(x, y)).y - _dropRightPanel.height + Constants.COLOR_BTN_SIZE;
		_dropRightPanel.addEventListener(MouseEvent.CLICK, palette_clickHandler);
		_dropRightPanel.graphics.beginFill(Constants.PANEL_COLOR);
		_dropRightPanel.graphics.drawRect(0, 0, _dropRightPanel.width, _dropRightPanel.height);
		_dropRightPanel.graphics.endFill();
	}

	//--------------------------------------------------------------------------
	//
	//  Private methods
	//
	//--------------------------------------------------------------------------

	private function colorizeButton(button:Sprite, color:uint, alpha:Number = 1):void {
		button.graphics.clear();
		button.graphics.beginFill(color, alpha);
		button.graphics.drawRect(0, 0, Constants.COLOR_BTN_SIZE, Constants.COLOR_BTN_SIZE);
		button.graphics.endFill();
	}

	//--------------------------------------------------------------------------
	//
	//  Event handlers
	//
	//--------------------------------------------------------------------------

	private function mainButton_clickHandler(event:MouseEvent):void {
		if (stage.contains(_dropRightPanel)) {
			stage.removeChild(_dropRightPanel);
		} else {
			dispatchEvent(new ToolEvent(ToolEvent.SUB_PANEL_OPENED));
			stage.addChild(_dropRightPanel);
		}
	}

	private function palette_clickHandler(event:MouseEvent):void {
		closePanel();

		var color:uint = _paletteBmpData.getPixel32(event.localX, event.localY);
		var alpha:Number = (color >> 24 & 0xFF) / 0xFF;
		if (alpha == 0) return;

		colorizeButton(_mainButton, color, alpha);
		dispatchEvent(new ToolEvent(ToolEvent.COLOR_CHANGED, -1, 1, color, alpha));
	}
}
}

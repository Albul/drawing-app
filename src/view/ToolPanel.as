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
import flash.display.Sprite;
import flash.events.MouseEvent;

public class ToolPanel extends Sprite {

	public static const TOOL_PANEL_WIDTH:int = 50;
	public static const GAP:int = 8;

	[Embed(source='../../assets/pencil.png')] private static const IcPencil:Class;
	[Embed(source='../../assets/rect.png')] private static const IcRect:Class;
	[Embed(source='../../assets/ellipse.png')] private static const IcEllipse:Class;
	[Embed(source='../../assets/eraser.png')] private static const IcEraser:Class;
	[Embed(source='../../assets/save.png')] private static const IcSave:Class;
	[Embed(source='../../assets/trash.png')] private static const IcTrash:Class;

	public function ToolPanel() {
	}

	//--------------------------------------------------------------------------
	//
	//  Public methods
	//
	//--------------------------------------------------------------------------

	public function init():void {
		drawBg();

		// Pencil button
		var pencilButton:Sprite = new Sprite();
		pencilButton.buttonMode = true;
		var pencilBmp:Bitmap = new Bitmap(new IcPencil().bitmapData);
		pencilButton.addChild(pencilBmp);
		pencilButton.x = (TOOL_PANEL_WIDTH - pencilButton.width) / 2;
		pencilButton.y = GAP;
		addChild(pencilButton);
		pencilButton.addEventListener(MouseEvent.CLICK, pencilButton_clickHandler);

		// Rect button
		var rectButton:Sprite = new Sprite();
		rectButton.buttonMode = true;
		var rectBmp:Bitmap = new Bitmap(new IcRect().bitmapData);
		rectButton.addChild(rectBmp);
		rectButton.x = pencilButton.x;
		rectButton.y = pencilButton.y + pencilButton.height + GAP;
		addChild(rectButton);
		rectButton.addEventListener(MouseEvent.CLICK, rectButton_clickHandler);

		// Ellipse button
		var ellipseButton:Sprite = new Sprite();
		ellipseButton.buttonMode = true;
		var ellipseBmp:Bitmap = new Bitmap(new IcEllipse().bitmapData);
		ellipseButton.addChild(ellipseBmp);
		ellipseButton.x = pencilButton.x;
		ellipseButton.y = rectButton.y + rectButton.height + GAP;
		addChild(ellipseButton);
		ellipseButton.addEventListener(MouseEvent.CLICK, ellipseButton_clickHandler);

		// Eraser button
		var eraserButton:Sprite = new Sprite();
		eraserButton.buttonMode = true;
		var eraserBmp:Bitmap = new Bitmap(new IcEraser().bitmapData);
		eraserButton.addChild(eraserBmp);
		eraserButton.x = pencilButton.x;
		eraserButton.y = ellipseButton.y + ellipseButton.height + GAP;
		addChild(eraserButton);
		eraserButton.addEventListener(MouseEvent.CLICK, eraserButton_clickHandler);

		// Thickness button
		var thicknessButton:ThicknessButton = new ThicknessButton();
		thicknessButton.x = pencilButton.x;
		thicknessButton.y = eraserButton.y + eraserButton.height + GAP;
		addChild(thicknessButton);
		thicknessButton.init();

		// Divider
		var divider:Sprite = new Sprite();
		divider.graphics.beginFill(Constants.GRAY_COLOR, 1);
		divider.graphics.drawRect(0, 0, TOOL_PANEL_WIDTH, 2);
		divider.graphics.endFill();
		divider.y = thicknessButton.y + thicknessButton.height + 2 * GAP;
		addChild(divider);

		// Save button
		var saveButton:Sprite = new Sprite();
		saveButton.buttonMode = true;
		var saveBmp:Bitmap = new Bitmap(new IcSave().bitmapData);
		saveButton.addChild(saveBmp);
		saveButton.x = pencilButton.x;
		saveButton.y = divider.y + divider.height + 2 * GAP;
		addChild(saveButton);
		saveButton.addEventListener(MouseEvent.CLICK, saveButton_clickHandler);

		// Trash can button
		var trashButton:Sprite = new Sprite();
		trashButton.buttonMode = true;
		var trashBmp:Bitmap = new Bitmap(new IcTrash().bitmapData);
		trashButton.addChild(trashBmp);
		trashButton.x = pencilButton.x;
		trashButton.y = saveButton.y + saveButton.height + GAP;
		addChild(trashButton);
		trashButton.addEventListener(MouseEvent.CLICK, trashButton_clickHandler);
	}

	public function drawBg():void {
		graphics.clear();
		graphics.beginFill(Constants.PANEL_COLOR);
		graphics.drawRect(0, 0, TOOL_PANEL_WIDTH, stage.stageHeight);
		graphics.endFill();
	}

	//--------------------------------------------------------------------------
	//
	//  Event handlers
	//
	//--------------------------------------------------------------------------

	private function pencilButton_clickHandler(event:MouseEvent):void {
		dispatchEvent(new ToolEvent(ToolEvent.TOOL_SELECTED, Constants.PENCIL_TOOL));
	}

	private function rectButton_clickHandler(event:MouseEvent):void {
		dispatchEvent(new ToolEvent(ToolEvent.TOOL_SELECTED, Constants.RECT_TOOL));
	}

	private function ellipseButton_clickHandler(event:MouseEvent):void {
		dispatchEvent(new ToolEvent(ToolEvent.TOOL_SELECTED, Constants.ELLIPSE_TOOL));
	}

	private function eraserButton_clickHandler(event:MouseEvent):void {
		dispatchEvent(new ToolEvent(ToolEvent.TOOL_SELECTED, Constants.ERASER_TOOL));
	}

	private function saveButton_clickHandler(event:MouseEvent):void {
		dispatchEvent(new ToolEvent(ToolEvent.SAVE_CLICKED));
	}

	private function trashButton_clickHandler(event:MouseEvent):void {
		dispatchEvent(new ToolEvent(ToolEvent.TRASH_CLICKED));
	}
}
}

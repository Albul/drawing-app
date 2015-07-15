package {

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;

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

		_toolPanel = new ToolPanel();
		addChild(_toolPanel);
		_toolPanel.init();

		_board = new Sprite();
		addChild(_board);

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

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
package utils {

public class MathUtils {

	static public function roundTo(value:Number, to:Number):Number {
		return value - value % to;
	}

	static public function toRadians(val:Number):Number {
		return val * Math.PI / 180;
	}

	static public function toDegrees(val:Number):Number {
		return val * 180 / Math.PI;
	}

	static public function sign(val:Number):Number {
		return (val == 0? 0 : (val < 0? -1 : 1));
	}
}
}
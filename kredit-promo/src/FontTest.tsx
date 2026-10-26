import {AbsoluteFill} from 'remotion';
import {C, FONT} from './theme';

const SAMPLE = 'әғқңөұүһі ӘҒҚҢӨҰҮҺІ';

/** Проверка казахских букв в обоих шрифтах. */
export const FontTest: React.FC = () => (
	<AbsoluteFill style={{background: C.navy, color: C.white, padding: 96, gap: 24}}>
		{[
			[FONT.display, 500],
			[FONT.display, 700],
			[FONT.text, 400],
			[FONT.text, 700],
		].map(([family, weight]) => (
			<div key={`${family}${weight}`} style={{fontFamily: family as string, fontWeight: weight, fontSize: 80}}>
				{SAMPLE} <span style={{fontSize: 28, color: C.ice}}>{String(family).split(',')[0]} {weight}</span>
			</div>
		))}
	</AbsoluteFill>
);

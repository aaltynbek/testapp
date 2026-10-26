import {AbsoluteFill} from 'remotion';
import {C, MARGIN} from '../theme';
import {stackGrownAt, transitionStart} from '../world/formations';
import {stackLabelAnchors} from '../world/layout';
import {Anchor} from '../ui/Anchor';
import {TopLeft} from '../ui/Heading';
import {Reveal, display, text} from '../ui/Text';

const SCENE_FROM = 405;
const LABELS = [
	['1 кредит', '30 акад. сағат'],
	['60 кредит', 'толық оқу жылы'],
	['≥ 120 кредит', 'ғылыми-педагогикалық магистратура'],
];

export const Stacks: React.FC = () => (
	<AbsoluteFill>
		<TopLeft>
			<Reveal delay={8} style={display(56)}>
				Жүктеме кредитпен өлшенеді
			</Reveal>
		</TopLeft>
		<div style={{position: 'absolute', top: MARGIN, right: MARGIN}}>
			<Reveal delay={20} style={{...text(24), color: C.ice}}>
				ECTS: 1 кредит ≈ 25–30 сағат
			</Reveal>
		</div>
		{stackLabelAnchors().map((a, n) => {
			// подпись появляется, когда стопка почти выросла
			const delay = transitionStart(4) - SCENE_FROM + stackGrownAt(n) - 8;
			return (
				<Anchor key={n} {...a}>
					<div style={{textAlign: 'center'}}>
						<Reveal delay={delay} style={{...display(40), color: C.gold}}>
							{LABELS[n][0]}
						</Reveal>
						<Reveal delay={delay + 4} style={{...text(24), color: C.ice, marginTop: 4}}>
							{LABELS[n][1]}
						</Reveal>
					</div>
				</Anchor>
			);
		})}
	</AbsoluteFill>
);

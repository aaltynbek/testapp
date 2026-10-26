import {AbsoluteFill} from 'remotion';
import {C, MARGIN} from '../theme';
import {orbitLabelAnchors} from '../world/layout';
import {Anchor} from '../ui/Anchor';
import {TopLeft} from '../ui/Heading';
import {Reveal, display, text} from '../ui/Text';

const LABELS = ['Оқу нәтижесі', 'Оқу әрекеті', 'Бағалау'];

export const Orbits: React.FC = () => (
	<AbsoluteFill>
		<TopLeft>
			<Reveal delay={8} style={{...text(26, 700), color: C.gold, letterSpacing: '0.04em'}}>
				Сындарлы сәйкестендіру
			</Reveal>
		</TopLeft>
		{orbitLabelAnchors().map((a, n) => (
			<Anchor key={n} {...a}>
				<Reveal delay={22 + n * 10} style={display(36, 500)}>
					{LABELS[n]}
				</Reveal>
			</Anchor>
		))}
		<div
			style={{
				position: 'absolute',
				left: MARGIN,
				right: MARGIN,
				bottom: MARGIN,
				textAlign: 'center',
			}}
		>
			<Reveal delay={56} style={text(34, 700)}>
				Кредит оқу нәтижесі расталғанда ғана беріледі
			</Reveal>
		</div>
	</AbsoluteFill>
);

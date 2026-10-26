import {AbsoluteFill} from 'remotion';
import {C} from '../theme';
import {pathLabelAnchors} from '../world/layout';
import {Anchor} from '../ui/Anchor';
import {TopLeft} from '../ui/Heading';
import {Reveal, display, plate, text} from '../ui/Text';

const LABELS = ['Элективтер каталогы', 'Жеке оқу жоспары', 'Пәнге тіркелу', 'Оқу нәтижесі'];
export const Path: React.FC = () => (
	<AbsoluteFill>
		<TopLeft>
			<Reveal delay={8} style={display(56)}>
				Студент — өз траекториясының авторы
			</Reveal>
			<Reveal delay={16} style={{...text(28), color: C.ice, marginTop: 10}}>
				эдвайзердің көмегімен
			</Reveal>
		</TopLeft>
		{pathLabelAnchors().map((a, n) => (
			<Anchor key={n} {...a}>
				<Reveal delay={30 + n * 12} style={{...text(30, 700), ...plate}}>
					{LABELS[n]}
				</Reveal>
			</Anchor>
		))}
	</AbsoluteFill>
);

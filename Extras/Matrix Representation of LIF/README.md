## Matrix Representation of LIF

Single neuron의 LIF 모델은 다음과 같은 식으로 표현된다.
($V$: 막전위, $\tau$: 불응기 상수, $E_0$: 휴지 전위, $I_o$: 유입 전류, $R$: 전압, $dQ$: 유입 전하량)

$$ \frac {dV}{dt} = \frac {1} {\tau} (E_0-V+I_o R) $$


$$ {dV} = \frac {dt} {\tau} (E_0-V+I_o R) $$


### 전위 전이 함수

위의 시스템을 수치 시뮬레이션을 통해 구할 때, $dt, \tau, E_0, R$은 상수로 가정한다. 그렇다면, $dV$는 다음과 같이 $V$와 $I$의 선형 연산으로 계산할 수 있다. 

$$ dv : \begin{pmatrix} V \\ I_o\end{pmatrix} \mapsto (\frac {dt} {\tau})E_o - (\frac {dt} {\tau})V + (\frac {dt} {\tau})I_oR$$

다만, 위 식은 **선형 변환이 아니다**. $E_0$항이 남아있어 선형 변환이 될 수 없다. 이를 해소하기 위해, 전위의 기준값을 $E_0$로 설정하자. 즉, $E_0 = 0$ 으로 설정한다. 이는 '전위'의 개념 자체가 '에너지의 차이'로 정의되므로, 그 기준을 바꿔도 똑같이 작동하기 때문에 물리적으로 타당한 설정이다. 수학적으로도, 전위에 일정한 상수를 더하는 것은 미분하면 사라지기에, 미분방정식으로 다룰 때 전혀 영향을 미치지 않는다.
$$ dv: \begin{pmatrix} V \\ I_o\end{pmatrix} \mapsto - (\frac {dt} {\tau})V + (\frac {dt} {\tau})I_oR$$
이를 바탕으로, 전위 전이 함수($T_V$)는 다음과 같이 구할 수 있다. 다음 식에서의 전위는 막 사이의 전위에서 휴지 전위를 뺀 값이다.

$$
\begin{align*}
T_V(V, I_o) =  (1- \frac {dt} {\tau})V + (\frac {dt} {\tau})I_oR
\end{align*}
$$

이를 행렬로 표현하면 다음과 같다.
$$
for \;\mathbf x = \begin{pmatrix} V \\ I_o\end{pmatrix}, \quad V_{\text{next}} =\begin{pmatrix}  1-\frac {dt}{\tau} ,& \frac{dt}{\tau} \end{pmatrix} \mathbf x
$$
그러므로, 다음 행렬을 정의하자
$$ M_V = \begin{pmatrix}  1-\frac {dt}{\tau} ,& \frac{dt}{\tau} \end{pmatrix}, \quad V_{\text{next}} = M_V \mathbf x$$

여러 뉴런($1, 2, \dots, i$)의 다음 전위를 구하려면 다음을 이용할 수 있다.
$$
M_V[\mathbf x_1, \mathbf x_2, \dots, \mathbf x_i]
$$

### 스파이크 계산 함수
위의 과정에서 구한 다음 전위가 특정 역치를 넘으면 그 뉴런에서 스파이크가 발생한다. 스파이크 직후에는 막이 과분극되어 음의 전위를 갖게 된다. 이를 다음과 같이 표현하자. 이는, 선형변환은 아니나, **활성화 함수**의 모델링이 된다. (당연히 활성화 함수는 선형이면 안된다)
- $E_1$: 역치 전위
- $E_{-1}$: 과분극 전위
$$
(\text{스파이크 여부}) = \begin{cases} 1 \quad (if \; V>E_1) &\Rightarrow V_{next} = E_{-1} \\ 0 \quad (else) &\Rightarrow V_{next} = V   \end{cases}
$$

더 나아가, 전위가 음수인 경우(참고: $E_0 = 0$으로 가정) 막전위는 빠르게 회복된다. 이를 바탕으로 다음을 추론할 수 있다.
$$
(\text{스파이크만 고려한 다음 전위}) = \begin{cases} E_{-1} \quad& (if \; V>E_1) \\ V \quad& (0 \leq V \leq E_1)  \\ 0 \quad& (V < 0) \end{cases} 
$$

이를 위해 다음 논리 변수를 정의하자.
$$
\begin{cases} p^+(V) = V > E_1 \\ p^-(V) = V < 0  \end{cases}
$$

이를 이용하면, 스파이크 발생 여부($T_S$)와 다음 전위($T_V$)를 다음과 같이 구할 수 있다.

$$
\begin{align*}
T_S(V) =& p^+ \\ 
T_V(V) =& (1-p^+)(1-p^-)V + p^+E_{-1}
\end{align*}
$$


### 종합 함수
위의 두 함수를 합성 및 데카르트 곱을 하여 다음과 같은 상태 결정 함수를 구성할 수 있다.
$$
\begin{align*}
&T: \mathbf x \mapsto \mathbf y = \begin{pmatrix} T_S(M_V\mathbf x) \\ T_V(M_V\mathbf x) \end{pmatrix}\\
&S = e^1T(\mathbf x) \\
&V_{\text{next}} = e_2T(\mathbf x) 
\end{align*}
$$

위와 같은 방식은 여러 뉴런을 행렬로 표현할 때, 모든 뉴런의 병렬 연산이 가능하게 하며, 그래프 수준에서의 매크로 연산이 가능하도록 한다.
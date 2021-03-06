require 'spec_helper'

describe Graphunk::WeightedUndirectedGraph do
  let(:graph) do
    Graphunk::WeightedUndirectedGraph.new(
      {'a' => ['b', 'c'], 'b' => ['c', 'd'], 'c' => [], 'd' => [] },
      { ['a','b'] => 2, ['a','c'] => 4, ['b','c'] => 8, ['b','d'] => 5 }
    )
  end

  describe 'remove_vertex' do
    context 'the vertex exists' do
      before do
        graph.remove_vertex('c')
      end

      it 'removes edges' do
        expect(graph.edges).to match_array [ ['a','b'], ['b','d'] ]
      end

      it 'removes vertices' do
        expect(graph.vertices).to match_array ['a','b','d']
      end

      it 'removes weights' do
        expect(graph.weights).to_not include [['a','c'], ['b','c']]
      end
    end

    context 'the vertex does not exist' do
      it 'raises an ArgumentError' do
        expect{graph.remove_vertex('f')}.to raise_error ArgumentError
      end
    end
  end

  describe 'remove_edge' do
    context 'the edge exists' do
      before do
        graph.remove_edge('a','b')
      end

      it 'removes edge' do
        expect(graph.edges).to match_array [ ['a','c'], ['b','c'], ['b','d'] ]
      end

      it 'removes weight' do
        expect(graph.weights).to_not include ['a','b']
      end
    end

    context 'the edge does not exist' do
      it 'raises an ArgumentError' do
        expect{graph.remove_edge('f','z')}.to raise_error ArgumentError
      end
    end
  end

  describe 'add_edge' do
    context 'vertices exist and edge does not exist' do
      before do
        graph.add_edge('a','d',6)
      end

      it 'defines the weight' do
        expect(graph.weights).to include ['a','d'] => 6
      end

      it 'defines the edge' do
        expect(graph.edges).to include ['a','d']
      end
    end

    context 'one of the vertices does not exist' do
      it 'raises an ArgumentError' do
        expect{graph.add_edge('a','e',4)}.to raise_error ArgumentError
      end
    end

    context 'the edge already exists' do
      it 'raises an ArgumentError' do
        expect{graph.add_edge('a','b', 4)}.to raise_error ArgumentError
      end
    end
  end

  describe 'edge_weight' do
    context 'edge exists' do
      it 'gets the weight of the given edge' do
        expect(graph.edge_weight('a','b')).to eql 2
      end
    end

    context 'edge does not exist' do
      it 'raises an ArgumentError' do
        expect{graph.edge_weight('z','f')}.to raise_error ArgumentError
      end
    end
  end

  describe 'adjust_weight' do
    context 'the edge exists' do
      it 'adjusts the value in the weight hash' do
        graph.adjust_weight('a','b', 1)
        expect(graph.weights).to include ['a','b'] => 1
      end
    end

    context 'the edge does not exist' do
      it 'raises an ArgumentError' do
        expect{graph.adjust_weight('a','f',3)}.to raise_error ArgumentError
      end
    end
  end

  describe 'minimum_spanning_tree' do
    let(:graph) do
      Graphunk::WeightedUndirectedGraph.new(
        { 'a' => ['b','d'], 'b' => ['c','d','e'], 'c' => ['e','f'], 'd' => ['e'], 'e' => ['f'], 'f' => [] },
        { ['a','b'] => 1, ['a','d'] => 3, ['b','c'] => 6, ['b','d'] => 5, ['b','e'] => 1, ['c','e'] => 5, ['c','f'] => 2, ['d','e'] => 1, ['e','f'] => 4 }
      )
    end

    it 'contains all the vertices in the original graph' do
      expect(graph.minimum_spanning_tree.vertices).to match_array graph.vertices
    end

    it 'contains only the edges in the minimum spanning tree ' do
      expect(graph.minimum_spanning_tree.edges).to match_array [ ['a','b'], ['b', 'e'], ['c','f'], ['d','e'], ['e','f'] ]
    end
  end
end
